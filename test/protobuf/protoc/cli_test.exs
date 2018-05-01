defmodule Protobuf.Protoc.CLITest do
  use ExUnit.Case, async: true
  alias Protobuf.Protoc.{CLI, Context}

  setup do
    {:ok, ctx: %Context{}}
  end

  test "parse_params/2 parse plugins", %{ctx: ctx} do
    ctx = CLI.parse_params(ctx, "plugins=grpc")
    assert ctx == %Context{plugins: ["grpc"]}
  end

  test "parse_params/2 parse custom namespace", %{ctx: ctx} do
    ctx = CLI.parse_params(ctx, "customns=My.Custom.Namespace")
    assert ctx == %Context{custom_namespace: "My.Custom.Namespace"}
  end
end
