package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var inputStr = strings.TrimSpace(`3,4,3,1,2`)

func TestPart1(t *testing.T) {
	assert.Equal(t, 5, Part1(inputStr, 0), "they should be equal")
	assert.Equal(t, 26, Part1(inputStr, 18), "they should be equal")
	assert.Equal(t, 5934, Part1(inputStr, 80), "they should be equal")
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 26984457539, Part1(inputStr, 256), "they should be equal")
}
