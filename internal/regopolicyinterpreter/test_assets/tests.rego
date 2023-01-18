package test

import future.keywords

test_is_greater_than_true if {
    result := is_greater_than with input as {"a": 2, "b": 1}
    result["result"]
}

test_is_greater_than_false if {
    result := is_greater_than with input as {"a": 1, "b": 2}
    not result["result"]
}

test_add if {
    result := add with input as {"a": 2, "b": 1}
    result["result"] == 3
}

test_create if {
    result := create with input as {"name": "test", "a": 2, "b": 1}

    result["success"]

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

test_append if {
    result := append with input as {"name": "test", "a": 3, "b": 4}
        with data.metadata as {
            "test": {
                "greater": [2],
                "lesser": [1]
            }
        }

    result["success"]

    greater := result["metadata"][0]
    greater.name == "test"
    greater.action == "update"
    greater.key == "greater"
    greater.value == [2, 4]

    lesser := result["metadata"][1]
    lesser.name == "test"
    lesser.action == "update"
    lesser.key == "lesser"
    lesser.value == [1, 3]
}

test_compute_gap if {
    result := compute_gap with input as {"name": "test"}
        with data.metadata as {
            "test": {
                "greater": [2, 4],
                "lesser": [1, 3]
            }
        }    

    result["result"] == 2
    
    greater := result["metadata"][0]
    greater.name == "test"
    greater.action == "remove"
    greater.key == "greater"

    
    lesser := result["metadata"][1]
    lesser.name == "test"
    lesser.action == "remove"
    lesser.key == "lesser"   
}
