defmodule Protobuf.Protoc.Generator.Util do
  def trans_name(name) do
    Macro.camelize(name)
  end

  def join_name(list) do
    Enum.join(list, ".")
  end

  def attach_pkg(name, ""), do: name
  def attach_pkg(name, nil), do: name
  def attach_pkg(name, pkg), do: normalize_pkg_name(pkg) <> "." <> name

  def attach_raw_pkg(name, ""), do: name
  def attach_raw_pkg(name, nil), do: name
  def attach_raw_pkg(name, pkg), do: pkg <> "." <> name

  def attach_cns(name, nil), do: name
  def attach_cns(name, ""), do: name
  def attach_cns(name, cns), do: cns <> "." <> name

  def options_to_str(opts) do
    opts
    |> Enum.filter(fn {_, v} -> v end)
    |> Enum.map(fn {k, v} -> "#{k}: #{print(v)}" end)
    |> Enum.join(", ")
  end

  def trans_type_name(name, %{custom_namespace: cns} = ctx) do
    case find_type_package(name, ctx) do
      "" ->
        name |> String.trim_leading(".") |> normalize_type_name

      found_pkg ->
        name = name |> String.trim_leading("." <> found_pkg <> ".") |> normalize_type_name
        pkg_name = normalize_pkg_name(found_pkg) <> "." <> name

        attach_cns(pkg_name, cns)
    end
  end

  defp normalize_pkg_name(pkg) do
    pkg
    |> String.split(".")
    |> Enum.map(&Macro.camelize(&1))
    |> Enum.join(".")
  end

  defp find_type_package("." <> name, %{dep_pkgs: pkgs, package: pkg}) do
    case find_package_in_deps(name, pkgs) do
      nil -> pkg
      found_pkg -> found_pkg
    end
  end

  defp find_type_package(_, %{package: pkg}), do: pkg

  defp find_package_in_deps(_, []), do: nil

  defp find_package_in_deps(name, [pkg | tail]) do
    if String.starts_with?(name, pkg <> ".") do
      pkg
    else
      find_package_in_deps(name, tail)
    end
  end

  defp normalize_type_name(name) do
    name
    |> String.split(".")
    |> Enum.map(&Macro.camelize(&1))
    |> Enum.join(".")
  end

  def print(v) when is_atom(v), do: inspect(v)
  def print(v), do: v
end
