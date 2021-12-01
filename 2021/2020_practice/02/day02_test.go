package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var inputStr = strings.TrimSpace(`
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
`)

func TestValidPass(t *testing.T) {
	assert.Equal(t, Valid(inputStr), 2, "they should be equal")
}

func TestValidPass2(t *testing.T) {
	assert.Equal(t, Valid2(inputStr), 1, "they should be equal")
}
