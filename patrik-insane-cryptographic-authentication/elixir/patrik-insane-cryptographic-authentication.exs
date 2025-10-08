Mix.install([
  {:httpoison, "~> 2.0"},
  {:jason, "~> 1.4"}
])

defmodule PatrikInsaneCryptographicAuthentication do
  @alphabet "abcdefghijklmnopqrstuvwxyz"
  @username "igor"

  def run([filename]) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, ":"))
    |> Stream.map(&authenticate/1)
    |> Stream.map(&greetingToken/1)
    |> Stream.map(&greeting/1)
    |> Enum.each(&IO.puts/1)
  end

  def run(_) do
    IO.puts("Usage: elixir patrik-insane-cryptographic-authentication.exs <filename>")
  end

  defp authenticate([username, password]) do
    url = "https://code-club-website.patrik-dvoracek.workers.dev/rest/puzzle/2025/september/auth"
    body = %{type: "credentials", username: username, password: password}
    json_body = Jason.encode!(body)

    headers = [
      "Content-Type": "application/json",
      "X-Cookie-User": @username
    ]

    case HTTPoison.post(url, json_body, headers) do
      {:ok, %HTTPoison.Response{status_code: _, body: response_body}} ->
        case Jason.decode(response_body) do
          {:ok, %{"token" => token, "type" => "greeting"}} ->
            token
        end
    end
  end

  defp greetingToken(token) do
    token
    |> String.graphemes()
    |> Enum.reduce(100, fn char, total ->
      lowercase_char = String.downcase(char)

      case :binary.match(@alphabet, lowercase_char) do
        :nomatch ->
          total

        {index, _} ->
          <<ascii_value::utf8>> = lowercase_char
          rem((total + index + 1) * ascii_value, 4096)
      end
    end)
  end

  defp greeting(token) do
    url = "https://code-club-website.patrik-dvoracek.workers.dev/rest/puzzle/2025/september/auth"
    body = %{type: "greeting", token: token}
    json_body = Jason.encode!(body)

    headers = [
      "Content-Type": "application/json",
      "X-Cookie-User": @username
    ]

    case HTTPoison.post(url, json_body, headers) do
      {:ok, %HTTPoison.Response{status_code: _, body: response_body}} ->
        case Jason.decode(response_body) do
          {:ok, %{"result" => result, "type" => "authenticated"}} ->
            result
        end
    end
  end
end

PatrikInsaneCryptographicAuthentication.run(System.argv())
