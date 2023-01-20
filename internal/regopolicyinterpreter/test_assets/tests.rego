package test

import future.keywords

num_tests := 1000
num_pairs := 30
string_length := 10
mid_value := 100
max_value := 200

test_is_greater_than_true if {
    a_values := rand.int_array(mid_value, max_value, num_tests)
    b_values := rand.int_array(0, mid_value, num_tests)
    every i, a in a_values {
        b := b_values[i]
        result := is_greater_than with input as {"a": a, "b": b}
        result["result"]
    }
}

test_is_greater_than_false if {
    a_values := rand.int_array(0, mid_value, num_tests)
    b_values := rand.int_array(mid_value, max_value, num_tests)
    every i, a in a_values {
        b := b_values[i]
        result := is_greater_than with input as {"a": a, "b": b}
        not result["result"]
    }
}

test_add if {
    a_values := rand.float64_array(0, mid_value, num_tests)
    b_values := rand.float64_array(mid_value, max_value, num_tests)
    every i, a in a_values {
        b := b_values[i]
        result := add with input as {"a": a, "b": b}
        result["result"] = a + b
    }
}

test_create if {
    names := rand.string_array(string_length, num_tests, false)
    a_values := rand.int_array(mid_value, max_value, num_tests)
    b_values := rand.int_array(0, mid_value, num_tests)    

    every i, name in names {
        a := a_values[i]
        b := b_values[i]

        result := create with input as {"name": name, "a": a, "b": b}

        result["success"]

        greater := result["metadata"][0]
        greater.name == name
        greater.action == "add"
        greater.key == "greater"
        greater.value == [a]

        lesser := result["metadata"][1]
        lesser.name == name
        lesser.action == "add"
        lesser.key == "lesser"
        lesser.value == [b]
    }
}

test_append if {
    names := rand.string_array(string_length, num_tests, false)
    length_values := rand.int_array(1, num_pairs, num_tests)
    a_values := rand.int_array(mid_value, max_value, num_tests)
    b_values := rand.int_array(0, mid_value, num_tests)

    every i, name in names {
        length := length_values[i]
        metadata := {
            name: {
                "greater": rand.int_array(mid_value, max_value, length),
                "lesser": rand.int_array(0, mid_value, length)
            }
        }

        a := a_values[i]
        b := b_values[i]
        result := append with input as {"name": name, "a": a, "b": b}
                         with data.metadata as metadata

        result["success"]

        expected_greater = array.concat(metadata[name]["greater"], [a])
        expected_lesser = array.concat(metadata[name]["lesser"], [b])

        greater := result["metadata"][0]
        greater.name == name
        greater.action == "update"
        greater.key == "greater"
        greater.value == expected_greater

        lesser := result["metadata"][1]
        lesser.name == name
        lesser.action == "update"
        lesser.key == "lesser"
        lesser.value == expected_lesser
    }
}

test_compute_gap if {
    names := rand.string_array(string_length, num_tests, true)
    length_values := rand.int_array(1, num_pairs, num_tests)

    metadata := {name: values |
        some i
        name := names[i]
        length := length_values[i]
        values := {
            "greater": rand.int_array(mid_value, max_value, length),
            "lesser": rand.int_array(0, mid_value, length)
        }
    }

    every name in names {
        greater_values := metadata[name]["greater"]
        lesser_values := metadata[name]["lesser"]
        expected := sum([diff | some i
                         diff := greater_values[i] - lesser_values[i]])
        
        result := compute_gap with input as {"name": name}
                              with data.metadata as metadata

        result["result"] == expected

        greater := result["metadata"][0]
        greater.name == name
        greater.action == "remove"
        greater.key == "greater"

        
        lesser := result["metadata"][1]
        lesser.name == name
        lesser.action == "remove"
        lesser.key == "lesser"           
    } 
}
