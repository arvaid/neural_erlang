CREATE TABLE Neuron (
    id int,
    label varchar NOT NULL,
    node int NOT NULL,

    code varchar NOT NULL,
    is_started boolean,
    is_busy boolean,

    x int,
    y int,
    z int,

    value float,
    activation_value float,

    PRIMARY KEY (id),
    FOREIGN KEY (node) REFERENCES Node(id)
);

CREATE TABLE Relation (
    id int,
    n_from int,
    n_to int,
    label varchar,

    PRIMARY KEY (id),
    FOREIGN KEY (n_from) REFERENCES Neuron(id),
    FOREIGN KEY (n_to) REFERENCES Neuron(id)
);

CREATE TABLE Node (
    id int,
    name varchar,

    PRIMARY KEY (id)
)