defmodule Kitch.CryptoUtil do
  # Largely copypasta from trenpixster/addict: addict/lib/addict/crypto.ex
  # Reference: https://github.com/ueberauth/guardian/issues/152

  def sign(plaintext, key \\ secret_key()) when is_binary(plaintext) do
    :crypto.hmac(:sha256, key, plaintext) |> Base.url_encode64(padding: false)
  end

  def verify(plaintext, given_sig, key \\ secret_key()) when is_binary(plaintext) do
    base_sig = sign(plaintext, key)

    case base_sig == given_sig do
      true -> {:ok, nil}
      false -> {:error, :invalid_sig}
    end
  end

  # Reference:
  # https://github.com/dwyl/phoenix-ecto-encryption-example
  # https://www.thegreatcodeadventure.com/elixir-encryption-with-erlang-crypto/
  @aad "AES256GCM"

  def encrypt(plaintext, key \\ secret_key()) when is_binary(plaintext) do
    key = :base64.decode(key)
    iv = :crypto.strong_rand_bytes(16)

    {ciphertext, tag} = :crypto.block_encrypt(:aes_gcm, key, iv, {@aad, to_string(plaintext), 16})

    :base64.encode(iv <> tag <> ciphertext)
  end

  def decrypt(ciphertext, key \\ secret_key()) when is_binary(ciphertext) do
    key = :base64.decode(key)
    ciphertext = :base64.decode(ciphertext)

    <<iv::binary-16, tag::binary-16, ciphertext::binary>> = ciphertext

    :crypto.block_decrypt(:aes_gcm, key, iv, {@aad, ciphertext, tag})
  end

  def generate_key() do
    :crypto.strong_rand_bytes(16) |> :base64.encode()
  end

  def secret_key() do
    # Read during run time (rather than at compile time with module attribute)
    # so it can be set on the fly
    Application.get_env(:kitch, Kitch.CryptoUtil)[:secret_key]
  end
end
