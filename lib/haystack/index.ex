defmodule Haystack.Index do
  @moduledoc """
  A module for managing indexes.
  """

  alias __MODULE__
  alias Haystack.{Storage, Store}

  @enforce_keys ~w{attrs fields name ref storage}a

  defstruct @enforce_keys

  @type t :: %__MODULE__{
          attrs: %{insert: list(module), delete: list(module)},
          fields: %{Index.Field.k() => Index.Field.t()},
          name: atom,
          ref: Index.Field.t(),
          storage: struct()
        }

  @type opts :: Keyword.t()

  @doc """
  Create a new index.

  ## Examples

    iex> Index.new(:people)

  """
  @spec new(atom, opts) :: t
  def new(name, opts \\ []) do
    opts =
      opts
      |> Keyword.put(:name, name)
      |> Keyword.put(:fields, %{})
      |> Keyword.put_new(:storage, Storage.Memory.new([]))
      |> Keyword.put_new(:attrs, Store.Attr.default())

    struct(__MODULE__, opts)
  end

  @doc """
  Add a ref to the index.

  ## Examples

    iex> index = Index.new(:people)
    iex> Index.ref(index, Index.Field.new("id"))

  """
  @spec ref(t, Index.Field.t()) :: t
  def ref(index, ref) do
    %{index | ref: ref}
  end

  @doc """
  Add a field to the index.

  ## Examples

    iex> index = Index.new(:people)
    iex> Index.field(index, Index.Field.new("name"))

  """
  @spec field(t, Index.Field.t()) :: t
  def field(index, field) do
    %{index | fields: Map.put(index.fields, field.k, field)}
  end

  @doc """
  Set the storage on the index.

  ## Examples

    iex> index = Index.new(:people)
    iex> Index.storage(index, Storage.Memory.new())

  """
  @spec storage(t, struct) :: t
  def storage(index, storage) do
    %{index | storage: storage}
  end
end
