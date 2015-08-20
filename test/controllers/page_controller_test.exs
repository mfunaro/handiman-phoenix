defmodule Handiman.PageControllerTest do
  use Handiman.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "Welcome to Handiman"
  end
end
