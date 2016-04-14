defmodule Chop do
  def guess(actual, l..h) do
    m = div(h - l, 2) + l
    guess(actual, m, l..h)
  end

  def guess(actual, guessed, _) when guessed == actual do
    print(guessed)
  end
  
  def guess(actual, guessed, l.._) when guessed > actual do
    print(guessed)
    guess(actual, l..guessed)
  end
  
  def guess(actual, guessed, _..h) when guessed < actual do
    print(guessed)
    guess(actual, guessed..h)
  end
  
  def print(value) do 
    IO.puts "It's #{value}"
  end
end