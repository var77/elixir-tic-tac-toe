defmodule XoCache.Helpers do
  def string_keys_to_atoms(map) do
    case map do
      %_{} -> Map.from_struct map
      _ -> for {key, val} <- map, into: %{}, do: {if(is_atom(key), do: key, else: String.to_atom(key)), val}
    end
  end
end
