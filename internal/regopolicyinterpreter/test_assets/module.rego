package module

subtract := result {
    result := input.a - input.b
}

subtract := result {
    result := concat("-", [input.a, input.b])
}