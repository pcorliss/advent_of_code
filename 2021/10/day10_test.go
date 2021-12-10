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

func TestReverseOdd(t *testing.T) {
	input := []string{"c", "b", "a"}
	expected := []string{"a", "b", "c"}
	assert.Equal(t, expected, ReverseStack(input), "they should be equal")
}

func TestReverseEven(t *testing.T) {
	input := []string{"d", "c", "b", "a"}
	expected := []string{"a", "b", "c", "d"}
	assert.Equal(t, expected, ReverseStack(input), "they should be equal")
}

func TestFinishingLine(t *testing.T) {
	lines := LinesToChars(inputStr)
	expected := []string{"}", "}", "]", "]", ")", "}", ")", "]"}
	assert.Equal(t, expected, FinishLine(lines[0]), "they should be equal")
}

func TestStackScore(t *testing.T) {
	lines := LinesToChars(inputStr)
	finish := FinishLine(lines[9])
	assert.Equal(t, 294, StackScore(finish), "they should be equal")
}

func TestStackScoreLong(t *testing.T) {
	lines := LinesToChars(inputStr)
	finish := FinishLine(lines[0])
	assert.Equal(t, 288957, StackScore(finish), "they should be equal")
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 288957, Part2(inputStr), "they should be equal")
}
