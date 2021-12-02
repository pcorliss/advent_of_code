package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var inputStr = strings.TrimSpace(`
forward 5
down 5
forward 8
up 3
down 8
forward 2
`)

func TestPart1(t *testing.T) {
	assert.Equal(t, 150, Part1(inputStr), "they should be equal")
}

// func TestPart2(t *testing.T) {
// 	assert.Equal(t, 241861950, Part2(inputStr), "they should be equal")
// }
