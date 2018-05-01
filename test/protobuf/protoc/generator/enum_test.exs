defmodule Protobuf.Protoc.Generator.EnumTest do
  use ExUnit.Case, async: true

  alias Protobuf.Protoc.Context
  alias Protobuf.Protoc.Generator.Enum, as: Generator

  setup do
    desc = %Google.Protobuf.EnumDescriptorProto{
      name: "EnumFoo",
      options: nil,
      value: [
        %Google.Protobuf.EnumValueDescriptorProto{name: "A", number: 0},
        %Google.Protobuf.EnumValueDescriptorProto{name: "B", number: 1}
      ]
    }

    {:ok, desc: desc}
  end

  test "generate/2 generates enum type messages", %{desc: desc} do
    ctx = %Context{package: ""}

    msg = Generator.generate(ctx, desc)
    assert msg =~ "defmodule EnumFoo do\n"
    assert msg =~ "use Protobuf, enum: true\n"
    refute msg =~ "defstruct "
    assert msg =~ "field :A, 0\n  field :B, 1\n"
  end

  test "generate/2 generates enum type messages with custom namespace", %{desc: desc} do
    ctx = %Context{package: "", custom_namespace: "My.Namespace"}

    msg = Generator.generate(ctx, desc)
    assert msg =~ "defmodule My.Namespace.EnumFoo do\n"
    assert msg =~ "use Protobuf, enum: true\n"
    refute msg =~ "defstruct "
    assert msg =~ "field :A, 0\n  field :B, 1\n"
  end
end
