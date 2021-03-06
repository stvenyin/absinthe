defmodule Absinthe.SerializerTest do
  use Absinthe.Case, async: true

  alias Absinthe.Serializer

  describe "serialize/1" do
    test "serialize variables definition" do
      assert %Absinthe.Language.VariableDefinition{
               default_value: nil,
               loc: %{start_line: 1},
               type: %Absinthe.Language.NamedType{
                 loc: %{start_line: 1},
                 name: "Episode"
               },
               variable: %Absinthe.Language.Variable{
                 loc: %{start_line: 1},
                 name: "episode"
               }
             }
             |> Serializer.serialize() == "$episode: Episode"
    end

    test "serialize list" do
      assert %Absinthe.Language.ListType{
               loc: %{start_line: 1},
               type: %Absinthe.Language.NonNullType{
                 loc: nil,
                 type: %Absinthe.Language.NamedType{loc: %{start_line: 1}, name: "String"}
               }
             }
             |> Serializer.serialize() == "[String!]"
    end

    test "serialize selection sets" do
      assert %Absinthe.Language.SelectionSet{
               loc: %{end_line: 7, start_line: 2},
               selections: [
                 %Absinthe.Language.Field{
                   alias: "NM",
                   arguments: [],
                   directives: [],
                   loc: %{start_line: 3},
                   name: "name",
                   selection_set: nil
                 },
                 %Absinthe.Language.Field{
                   alias: nil,
                   arguments: [],
                   directives: [],
                   loc: %{start_line: 4},
                   name: "friends",
                   selection_set: %Absinthe.Language.SelectionSet{
                     loc: %{end_line: 6, start_line: 4},
                     selections: [
                       %Absinthe.Language.Field{
                         alias: nil,
                         arguments: [],
                         directives: [],
                         loc: %{start_line: 5},
                         name: "name",
                         selection_set: nil
                       }
                     ]
                   }
                 }
               ]
             }
             |> Serializer.serialize() == "{\nNM: name\nfriends {\nname\n}\n\n}\n"
    end

    test "serialize field" do
      assert %Absinthe.Language.Field{
               alias: nil,
               arguments: [
                 %Absinthe.Language.Argument{
                   loc: %{start_line: 2},
                   name: "episode",
                   value: %Absinthe.Language.Variable{
                     loc: %{start_line: 2},
                     name: "episode"
                   }
                 }
               ],
               directives: [],
               loc: %{start_line: 2},
               name: "hero",
               selection_set: %Absinthe.Language.SelectionSet{
                 loc: %{end_line: 7, start_line: 2},
                 selections: [
                   %Absinthe.Language.Field{
                     alias: nil,
                     arguments: [],
                     directives: [],
                     loc: %{start_line: 3},
                     name: "name",
                     selection_set: nil
                   },
                   %Absinthe.Language.Field{
                     alias: nil,
                     arguments: [],
                     directives: [],
                     loc: %{start_line: 4},
                     name: "friends",
                     selection_set: %Absinthe.Language.SelectionSet{
                       loc: %{end_line: 6, start_line: 4},
                       selections: [
                         %Absinthe.Language.Field{
                           alias: nil,
                           arguments: [],
                           directives: [],
                           loc: %{start_line: 5},
                           name: "name",
                           selection_set: nil
                         }
                       ]
                     }
                   }
                 ]
               }
             }
             |> Serializer.serialize() ==
               "hero(episode: $episode) {\nname\nfriends {\nname\n}\n\n}\n"
    end

    test "serialize list value" do
      assert %Absinthe.Language.ListValue{
               loc: %{start_line: 1},
               values: [
                 %Absinthe.Language.IntValue{
                   loc: %{start_line: 1},
                   value: 1
                 },
                 %Absinthe.Language.IntValue{
                   loc: %{start_line: 1},
                   value: 2
                 },
                 %Absinthe.Language.IntValue{
                   loc: %{start_line: 1},
                   value: 3
                 }
               ]
             }
             |> Serializer.serialize() == "[1, 2, 3]"
    end

    test "serialize object value" do
      assert %Absinthe.Language.ObjectValue{
               fields: [
                 %Absinthe.Language.ObjectField{
                   loc: %{start_line: 1},
                   name: "uuid",
                   value: %Absinthe.Language.IntValue{
                     loc: %{start_line: 1},
                     value: 1
                   }
                 }
               ],
               loc: %{start_line: 1}
             }
             |> Serializer.serialize() == "{uuid: 1}"
    end

    test "serialzie fragment spread" do
      assert %Absinthe.Language.FragmentSpread{
               directives: [],
               loc: %{start_line: 7},
               name: "NameAndAppearances"
             }
             |> Serializer.serialize() == "...NameAndAppearances"
    end

    test "serialize fragment" do
      assert %Absinthe.Language.Fragment{
               directives: [],
               loc: %{start_line: 13},
               name: "NameAndAppearances",
               selection_set: %Absinthe.Language.SelectionSet{
                 loc: %{end_line: 16, start_line: 13},
                 selections: [
                   %Absinthe.Language.Field{
                     alias: nil,
                     arguments: [],
                     directives: [],
                     loc: %{start_line: 14},
                     name: "name",
                     selection_set: nil
                   },
                   %Absinthe.Language.Field{
                     alias: nil,
                     arguments: [],
                     directives: [],
                     loc: %{start_line: 15},
                     name: "appearsIn",
                     selection_set: nil
                   }
                 ]
               },
               type_condition: %Absinthe.Language.NamedType{
                 loc: %{start_line: 13},
                 name: "Character"
               }
             }
             |> Serializer.serialize() ==
               "fragment NameAndAppearances on Character {\nname\nappearsIn\n}\n"
    end

    test "serialiez default variables" do
      assert %Absinthe.Language.VariableDefinition{
               default_value: %Absinthe.Language.StringValue{
                 loc: %{start_line: 1},
                 value: "JEDI"
               },
               loc: %{start_line: 1},
               type: %Absinthe.Language.NamedType{
                 loc: %{start_line: 1},
                 name: "Episode"
               },
               variable: %Absinthe.Language.Variable{
                 loc: %{start_line: 1},
                 name: "episode"
               }
             }
             |> Serializer.serialize() == "$episode: Episode = \"JEDI\""
    end

    test "serialize inline serializer" do
      assert %Absinthe.Language.InlineFragment{
               directives: [],
               loc: %{start_line: 3},
               selection_set: %Absinthe.Language.SelectionSet{
                 loc: %{end_line: 5, start_line: 3},
                 selections: [
                   %Absinthe.Language.Field{
                     alias: nil,
                     arguments: [],
                     directives: [],
                     loc: %{start_line: 4},
                     name: "primaryFunction",
                     selection_set: nil
                   }
                 ]
               },
               type_condition: %Absinthe.Language.NamedType{
                 loc: %{start_line: 3},
                 name: "Droid"
               }
             }
             |> Serializer.serialize() == "... on Droid {\nprimaryFunction\n}\n"
    end

    test "serialize operation definition" do
      assert %Absinthe.Language.Document{
               definitions: [
                 %Absinthe.Language.OperationDefinition{
                   directives: [],
                   loc: %{start_line: 1},
                   name: "createSession",
                   operation: :mutation,
                   selection_set: %Absinthe.Language.SelectionSet{
                     loc: %{end_line: 14, start_line: 1},
                     selections: [
                       %Absinthe.Language.Field{
                         alias: nil,
                         arguments: [
                           %Absinthe.Language.Argument{
                             loc: %{start_line: 2},
                             name: "session",
                             value: %Absinthe.Language.ObjectValue{
                               fields: [
                                 %Absinthe.Language.ObjectField{
                                   loc: %{start_line: 2},
                                   name: "user",
                                   value: %Absinthe.Language.ObjectValue{
                                     fields: [
                                       %Absinthe.Language.ObjectField{
                                         loc: %{start_line: 2},
                                         name: "email",
                                         value: %Absinthe.Language.Variable{
                                           loc: %{start_line: 2},
                                           name: "email"
                                         }
                                       },
                                       %Absinthe.Language.ObjectField{
                                         loc: %{start_line: 2},
                                         name: "password",
                                         value: %Absinthe.Language.Variable{
                                           loc: %{start_line: 2},
                                           name: "password"
                                         }
                                       }
                                     ],
                                     loc: %{start_line: 2}
                                   }
                                 }
                               ],
                               loc: %{start_line: 2}
                             }
                           }
                         ],
                         directives: [],
                         loc: %{start_line: 2},
                         name: "createSession",
                         selection_set: %Absinthe.Language.SelectionSet{
                           loc: %{end_line: 13, start_line: 2},
                           selections: [
                             %Absinthe.Language.Field{
                               alias: nil,
                               arguments: [],
                               directives: [],
                               loc: %{start_line: 3},
                               name: "token",
                               selection_set: nil
                             },
                             %Absinthe.Language.Field{
                               alias: nil,
                               arguments: [],
                               directives: [],
                               loc: %{start_line: 12},
                               name: "__typename",
                               selection_set: nil
                             }
                           ]
                         }
                       }
                     ]
                   },
                   variable_definitions: [
                     %Absinthe.Language.VariableDefinition{
                       default_value: nil,
                       loc: %{start_line: 1},
                       type: %Absinthe.Language.NonNullType{
                         loc: nil,
                         type: %Absinthe.Language.NamedType{
                           loc: %{start_line: 1},
                           name: "String"
                         }
                       },
                       variable: %Absinthe.Language.Variable{
                         loc: %{start_line: 1},
                         name: "email"
                       }
                     },
                     %Absinthe.Language.VariableDefinition{
                       default_value: nil,
                       loc: %{start_line: 1},
                       type: %Absinthe.Language.NonNullType{
                         loc: nil,
                         type: %Absinthe.Language.NamedType{
                           loc: %{start_line: 1},
                           name: "String"
                         }
                       },
                       variable: %Absinthe.Language.Variable{
                         loc: %{start_line: 1},
                         name: "password"
                       }
                     }
                   ]
                 }
               ],
               loc: nil
             }
             |> Serializer.serialize() ==
               "mutation createSession($email: String!, $password: String!) {\ncreateSession(session: {user: {email: $email, password: $password}}) {\ntoken\n__typename\n}\n\n}\n\n"
    end
  end
end
