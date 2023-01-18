package test

default is_greater_than := false

is_greater_than {
    input.a > input.b
}

add := result {
    result := input.a + input.b
}

add := result {
    result := concat("+", [input.a, input.b])
}

default create := {"success": false}

create := {"success": true, "metadata": [addGreater, addLesser]} {
    is_greater_than
    addGreater := {
        "name": input.name,
        "action": "add",
        "key": "greater",
        "value": [input.a]
    }
    addLesser := {
        "name": input.name,
        "action": "add",
        "key": "lesser",
        "value": [input.b]
    }
}

create := {"success": true, "metadata": [addGreater, addLesser]} {
    not is_greater_than
    addGreater := {
        "name": input.name,
        "action": "add",
        "key": "greater",
        "value": [input.b]
    }
    addLesser := {
        "name": input.name,
        "action": "add",
        "key": "lesser",
        "value": [input.a]
    }
}

default append := {"success": false}

default lists_exist := false

lists_exist {
    data.metadata[input.name]
}

append := result {
    not lists_exist
    result := create
}

append := {"success": true, "metadata": [updateGreater, updateLesser]} {
    is_greater_than
    updateGreater := {
        "name": input.name,
        "action": "update",
        "key": "greater",
        "value": array.concat(data.metadata[input.name].greater, [input.a])
    }
    updateLesser := {
        "name": input.name,
        "action": "update",
        "key": "lesser",
        "value": array.concat(data.metadata[input.name].lesser, [input.b])
    }
}

append := {"success": true, "metadata": [updateGreater, updateLesser]} {
    not is_greater_than
    updateGreater := {
        "name": input.name,
        "action": "update",
        "key": "greater",
        "value": array.concat(data.metadata[input.name].greater, [input.b])
    }
    updateLesser := {
        "name": input.name,
        "action": "update",
        "key": "lesser",
        "value": array.concat(data.metadata[input.name].lesser, [input.a])
    }
}

compute_gap := {"gap": result, "metadata": [removeGreater, removeLesser]} {
    diffs := [diff | some i
                      g := data.metadata[input.name].greater[i]
                      l := data.metadata[input.name].lesser[i]
                      diff := g - l]
    result := sum(diffs)

    removeGreater := {
        "name": input.name,
        "action": "remove",
        "key": "greater"
    }
    removeLesser := {
        "name": input.name,
        "action": "remove",
        "key": "lesser"
    }    
}

subtract := data.module.subtract
