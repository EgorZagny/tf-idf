defmodule TfIdf do
  @moduledoc """
  Documentation for `TfIdf`.
  """

  @doc """
  TF-IDF

  ## Examples

      iex> TfIdf.tf_idf("river", "Hobbit.txt")
      3.8022335741083125e-4

  """
  def readText(text) do
    {s, text} = File.read("texts/" <> text)
    if s == :ok do
      text
    else
      :ioerror
    end
  end

  def textToWords(text) do
    String.downcase(text)
    |> String.split([" ", ".", ",", ":", ";", "!", "?", "\"", "\n", "\r"]) 
    |> Enum.filter(fn(x) -> x != "" end)
  end

  def tf(word, text) do
    count = Enum.reduce(text, 0, fn(w, acc) -> if w == word, do: acc+1, else: acc end)
    count / Enum.count(text)
  end

  def idf(word, texts) do
    count = Enum.reduce(texts, 0, fn(t, acc) -> 
      if Enum.find_index(t, fn(w) -> w == word end) != nil, do: acc+1, else: acc end)
    if count != 0 do 
      :math.log(Enum.count(texts) / count)
    else 
      0
    end
  end

  def tf_idf(word, text) do
    if is_binary(word) and is_binary(text) do
      texts = ["Pollyanna.txt", "Hobbit.txt", "Silmarillion.txt", "One Hundred Years of Solitude.txt"]
      text = Enum.find_index(texts, fn(t) -> t == text end)
      if text != nil do
        texts = Enum.map(texts, fn(t) -> readText(t) end) |> Enum.map(fn(t) -> textToWords(t) end)
        tf(word, Enum.at(texts, text)) * idf(word, texts)
      else
        "this file does not exist"
      end
    else
      "invalid input"
    end
  end
end
