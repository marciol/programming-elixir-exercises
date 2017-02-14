defmodule WordCounter do
  # extract one word from args on pattern matching
  def count(scheduler) do
    send scheduler, { :ready, self() }
    receive do
      { :count, file_path, [word], client } ->
        send client, { :answer, file_path, count_in_file(file_path, word), self() }
        count(scheduler)
      { :shutdown } ->
        exit(:normal)
    end
  end

  defp count_in_file(file_path, word) do
    Regex.scan(~r/#{word}/, File.read!(file_path))
    |> List.flatten
    |> Enum.count
  end
end

defmodule Scheduler do
  # remove args from spawn, args should be passed by schedule
  def run(num_processes, module, func, args, to_calculate) do
    (1..num_processes)
    |> Enum.map(fn(_) -> spawn(module, func, [self()]) end)
    |> schedule_processes(func, args, to_calculate, [])
  end

  defp schedule_processes(processes, func, args, queue, results) do
    receive do 
      {:ready, pid} when length(queue) > 0 ->
        [ next | tail ] = queue
        send pid, {func, next, args, self()}
        schedule_processes(processes, func, tail, results)

      {:ready, pid} ->
        send pid, {:shutdown}
        if length(processes) > 1 do
          schedule_processes(List.delete(processes, pid), func, args, queue, results)
        else
          results
        end

      {:answer, item, result, _pid} ->
        schedule_processes(processes, func, args, queue, [ {item, result} | results ])
    end
  end
end

defmodule File.Recursive do
  def ls!(dir) do
    for file_name <- File.ls!(dir) do
      path = Path.join(dir, file_name) |> Path.absname
      if File.regular?(path), 
        do: path,
      else: ls!(path)
    end 
    |> List.flatten
  end
end

dir = "/home/marciol/Projects/umanni_hr/app/"

to_process = File.Recursive.ls!(dir)

numnber = 
  Scheduler.run(Enum.count(to_process), WordCounter, :count, ["cat"], to_process)
  |> Enum.reduce(0, fun({_, n}, acc) -> acc + n end)
