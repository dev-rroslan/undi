defmodule Undi.Admins do
    @moduledoc """
    The Admins context.
    """
  
    import Ecto.Query, warn: false
    alias Undi.Repo
    alias Undi.Admins.Admin
  
    def paginate_admins(params \\ %{}) do
      Flop.validate_and_run(Admin, params, for: Admin)
    end
  
    @doc """
    Returns the list of admins.
  
    ## Examples
  
        iex> list_admins()
        [%Admin{}, ...]
  
    """
    def list_admins do
      Repo.all(Admin)
    end
  
    @doc """
    Gets a single admin.
  
    Raises `Ecto.NoResultsError` if the Admin does not exist.
  
    ## Examples
  
        iex> get_admin!(123)
        %Admin{}
  
        iex> get_admin!(456)
        ** (Ecto.NoResultsError)
  
    """
    def get_admin!(id), do: Repo.get!(Admin, id)
  
    @doc """
    Gets a admin by email.
  
    ## Examples
  
        iex> get_admin_by_email("foo@example.com")
        %Admin{}
  
        iex> get_admin_by_email("unknown@example.com")
        nil
  
    """
    def get_admin_by_email(email) when is_binary(email) do
      Repo.get_by(Admin, email: email)
    end
  
    @doc """
    Creates a admin.
  
    ## Examples
  
        iex> create_admin(%{field: value})
        {:ok, %Admin{}}
  
        iex> create_admin(%{field: bad_value})
        {:error, %Ecto.Changeset{}}
  
    """
    def create_admin(attrs \\ %{}) do
      %Admin{}
      |> Admin.registration_changeset(attrs)
      |> Repo.insert()
    end
  
    @doc """
    Updates a admin.
  
    ## Examples
  
        iex> update_admin(admin, %{field: new_value})
        {:ok, %Admin{}}
  
        iex> update_admin(admin, %{field: bad_value})
        {:error, %Ecto.Changeset{}}
  
    """
    def update_admin(%Admin{} = admin, attrs) do
      admin
      |> Admin.changeset(attrs)
      |> Repo.update()
    end
  
    @doc """
    Deletes a admin.
  
    ## Examples
  
        iex> delete_admin(admin)
        {:ok, %Admin{}}
  
        iex> delete_admin(admin)
        {:error, %Ecto.Changeset{}}
  
    """
    def delete_admin(%Admin{} = admin) do
      Repo.delete(admin)
    end
  
    @doc """
    Returns an `%Ecto.Changeset{}` for tracking admin changes.
  
    ## Examples
  
        iex> change_admin(admin)
        %Ecto.Changeset{data: %Admin{}}
  
    """
    def change_admin(%Admin{} = admin, attrs \\ %{}) do
      Admin.changeset(admin, attrs)
    end
  end