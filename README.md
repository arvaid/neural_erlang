# Erlang neural net framework

EKCU thesis subject
## Build

```console
$ rebar3  compile
```
## Usage

The `system` module has the following `init` functions:

| Function                            | Spec                    | Description                                                                                                                             |
| - | - | - |
| `init()`                            | &ndash;                       | Create an empty network.                                                                                                                |
| `init(State)`                       | `State::#system_state{}` | Create network based on the given `State` record.                                                                                      |
| `init(Filename)`                    |   `Filename::binary()`                      | Create network from the file contents.                                                                                                  |
| `init(State, Nodes)`                | `State::#system{}`<br/>`Nodes::[node()]` | Create network based on the given `State` record. The neurons will be distributed equally among Erlang nodes.                           |
| `init(Filename, Nodes)`             | `Filename::binary()`<br/>`Nodes::[node()]` | Create network from the file contents. The neurons will be distributed equally among Erlang nodes.                                      |
| `init(State, Nodes, Priorities)`    | `State::#system_state{}`<br/>`Nodes::[node()]`<br/>`Priorities::[number()]` | Create network based on the given `State` record. The neurons will be distributed among Erlang nodes according to the given priorities. |
| `init(Filename, Nodes, Priorities)` | `Filename::binary()`<br/>`Nodes::[node()]`<br/>`Priorities::[number()]` | Create network from the file contents. The neurons will be distributed  among Erlang nodes according to the given priorities.    |

Once the system has created the network, the user can add or remove neurons with the following commands:


