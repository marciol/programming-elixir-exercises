defmodule DentonMunicipalAirportWeatherReport.CLI do
  @url Application.get_env :denton_municipal_airport_weather_report, :url

  def main(_) do
    process
  end 

  def process do
    result = HTTPoison.get(@url)

    case result do
      {:ok, %{body: body}}
        -> parse_response(body) |> format

      {_, %{status_code: status}}
        -> 
          IO.puts("Error #{status} on fetch denton municipal airport weather report.")
          System.halt(1)
    end
  end

  def parse_response(body) do
    body
    |> :xmerl_sax_parser.stream(event_fun: &event/3, event_state: [])
  end

  def format({_, result, _}) do
    for {k, v} <- result do
      :io.format('~*s ~*s~n', [-25, k ++ ':', -40, v])
    end
  end

  def event({:startElement, uri, local_name, qualified_name, attributes}, location, state) do
    [ {local_name, nil} | state ]
  end

  def event({:characters, str}, _, state) do
    [ h1 | t ] = state
    h2 = put_elem(h1, 1, str)
    [ h2 | t ]
  end

  def event(_, _, state), do: state

end