package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("04/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 04")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
}

func StringToBingo(input string) []int {
	nums := []int{}
	lines := strings.Split(input, "\n")
	for _, val := range strings.Split(lines[0], ",") {
		n, err := strconv.Atoi(val)
		if err != nil {
			panic(err)
		}
		nums = append(nums, n)
	}
	return nums
}

func StringToBoards(input string) [][5][5]int {
	boards := [][5][5]int{}
	lines := strings.Split(input, "\n")
	newBoard := [5][5]int{}
	y := 0

	for i, line := range lines {
		// fmt.Println("Line:", i, line)
		if i == 0 || len(line) == 0 {
			continue
		}

		for j, val := range strings.Fields(line) {
			n, err := strconv.Atoi(val)
			if err != nil {
				panic(err)
			}
			newBoard[y][j] = n
		}
		y++
		// fmt.Println("NewBoard:", newBoard, y)
		if y >= 5 {
			y = 0
			boards = append(boards, newBoard)
			newBoard = [5][5]int{}
			// fmt.Println("Boards:", boards)
		}
	}
	return boards
}

func Part1(input string) int {
	return 0
}

func Part2(input string) int {
	return 0
}
