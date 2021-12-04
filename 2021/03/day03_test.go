package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var inputStr = strings.TrimSpace(`
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
`)

func TestPart1(t *testing.T) {
	assert.Equal(t, Part1(inputStr)[0], 22, "they should be equal")
	assert.Equal(t, Part1(inputStr)[1], 9, "they should be equal")
	assert.Equal(t, Part1(inputStr)[2], 198, "they should be equal")
}

func TestPart2(t *testing.T) {
	assert.Equal(t, Part2(inputStr)[0], 23, "they should be equal")
	assert.Equal(t, Part2(inputStr)[1], 10, "they should be equal")
	assert.Equal(t, Part2(inputStr)[2], 230, "they should be equal")
}
