defmodule PlateSlateWeb.Schema.Query.Categories do
  use PlateSlateWeb.ConnCase, async: true

  setup do
    PlateSlate.Seeds.run()
  end

  @query """
  query($filter: CategoryFilter!) {
    categories(filter: $filter) {
      name
    }
  }
  """
  @variables %{filter: ""}
  test "categories field returns menu items" do
    conn = build_conn()
    conn = get conn, "/api", query: @query, variables: @variables
    assert json_response(conn, 200) == %{
      "data" => %{
        "categories" => [
          %{"name" => "Beverages"},
          %{"name" => "Sandwiches" },
          %{"name" => "Sides"},
        ]
      }
    }
  end

  @query """
  query($filter: CategoryFilter!){
    categories(filter: $filter) {
      name
    }
  }
  """
  @variables %{filter: %{ "name" =>  "bev"}}
  test "categories field returns menu items filtered by  name" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)
    assert json_response(response, 200) == %{
      "data" => %{
        "categories" => [
          %{"name" => "Beverages"},
        ]
      }
    }
  end
end
