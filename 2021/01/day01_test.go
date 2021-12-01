package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var inputStr = strings.TrimSpace(`
199
200
208
210
200
207
240
269
260
263
`)

func TestPart1(t *testing.T) {
	assert.Equal(t, 7, Part1(inputStr), "they should be equal")
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 5, Part2(inputStr), "they should be equal")
}
