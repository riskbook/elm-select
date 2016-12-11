module Example1 exposing (..)

import Html exposing (Html, text, div)
import Movies
import Select


type alias Movie =
    { id : String
    , label : String
    }


type alias Model =
    { movies : List Movie
    , selectedMovieId : Maybe String
    , selectState : Select.Model
    }


movies : List Movie
movies =
    List.map (\( id, name ) -> Movie id name) Movies.movies


type Msg
    = NoOp
    | OnQuery String
    | OnSelect Movie
    | SelectMsg (Select.Msg Movie)


selectConfig : Select.Config Msg Movie
selectConfig =
    { onQueryChange = OnQuery
    , onSelect = OnSelect
    , toLabel = .label
    }



-- select : Select.Select Movie


select =
    Select.new selectConfig Nothing


initialModel : Model
initialModel =
    { movies = movies
    , selectedMovieId = Nothing
    , selectState = select.model
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnQuery str ->
            ( model, Cmd.none )

        OnSelect movie ->
            ( { model | selectedMovieId = Just movie.id }, Cmd.none )

        SelectMsg subMsg ->
            let
                ( updated, cmd ) =
                    select.update subMsg model.selectState
            in
                ( { model | selectState = updated }, cmd )

        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    let
        selectedMovie =
            case model.selectedMovieId of
                Nothing ->
                    Nothing

                Just id ->
                    List.filter (\movie -> movie.id == id) movies
                        |> List.head
    in
        div []
            [ text (toString model.selectedMovieId)
            , Html.map SelectMsg (select.view model.selectState model.movies selectedMovie)
            ]