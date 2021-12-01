package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var inputStr = strings.TrimSpace(`
1721
979
366
299
675
1456
`)

func TestPart1(t *testing.T) {
	assert.Equal(t, Part1(inputStr), 514579, "they should be equal")
}

func TestPart2(t *testing.T) {
	assert.Equal(t, Part2(inputStr), 241861950, "they should be equal")
}
