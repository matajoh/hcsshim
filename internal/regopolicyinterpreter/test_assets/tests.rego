package test

import future.keywords

test_is_greater_than_true if {
    is_greater_than with input as {"a": 2, "b": 1}
}

test_is_greater_than_false if {
    not is_greater_than with input as {"a": 1, "b": 2}
}

test_create if {
    result := create with input as {"name": "test", "a": 2, "b": 1}
    greater := result["metadata"][0]
    greater.name == "test"
    greater.action == "add"
    greater.key == "greater"
    greater.value == [2]

    lesser := result["metadata"][1]
    lesser.name == "test"
    lesser.action == "add"
    lesser.key == "lesser"
    lesser.value == [1]
}