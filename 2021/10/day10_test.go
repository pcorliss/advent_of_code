package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var inputStr = strings.TrimSpace(`
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
`)

func TestCorruption(t *testing.T) {
	lines := LinesToChars(inputStr)
	assert.Equal(t, "}", Corrupt(lines[2]), "they should be equal")
	assert.Equal(t, ")", Corrupt(lines[4]), "they should be equal")
	assert.Equal(t, ")", Corrupt(lines[7]), "they should be equal")
}

func TestPart1(t *testing.T) {
	assert.Equal(t, 26397, Part1(inputStr), "they should be equal")
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 0, Part2(inputStr), "they should be equal")
}
