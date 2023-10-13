defmodule KakeguruiBank.AuthToken do
  @signing_salt "random_salt_here_42_is_the_answer_to_everything!"

  # hint: 86_400 seconds is 1 day
  @token_age_in_seconds 1 * 86_400

  def sign(user_cpf) do
    Phoenix.Token.sign(KakeguruiBankWeb.Endpoint, @signing_salt, user_cpf)
  end

  def verify(token) do
    case Phoenix.Token.verify(
           KakeguruiBankWeb.Endpoint,
           @signing_salt,
           token,
           max_age: @token_age_in_seconds
         ) do
      {:ok, data} -> {:ok, data}
      _error -> {:error, :unauthenticated}
    end
  end
end
