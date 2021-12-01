package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var testCases = []struct {
	n        int // input
	expected int // expected result
}{
	{1, 1},
	{2, 2},
	{3, 3},
	{4, 4},
	{5, 5},
}

func TestMain(t *testing.T) {
	for _, tt := range testCases {
		actual := Ident(tt.n)
		if actual != tt.expected {
			t.Errorf("Ident(%d): expected %d, actual %d", tt.n, tt.expected, actual)
		}
	}
}

var inputStr = strings.TrimSpace(`
1721
979
366
299
675
1456
`)

func TestDoublesTestify(t *testing.T) {
	assert.Equal(t, Doubles(inputStr, 2020), 514579, "they should be equal")
}

func TestTriplesTestify(t *testing.T) {
	assert.Equal(t, Triples(inputStr, 2020), 241861950, "they should be equal")
}
