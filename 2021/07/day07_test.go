package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var inputStr = strings.TrimSpace(`
16,1,2,0,4,2,7,1,2,14
`)

func TestPart1(t *testing.T) {
	assert.Equal(t, 2, Part1(inputStr)[0], "they should be equal")
	assert.Equal(t, 37, Part1(inputStr)[1], "they should be equal")
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 0, Part2(inputStr), "they should be equal")
}
