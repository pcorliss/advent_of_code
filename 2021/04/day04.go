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

// set := make(map[string]bool)
func WinningBoard(called map[int]bool, board [5][5]int) bool {
	matchesVertical := [5]int{}
	matchesDiag := [2]int{}
	for y, line := range board {
		matches := 0
		for x, val := range line {
			if called[val] {
				matches++
				matchesVertical[x]++
				if x == y {
					matchesDiag[0]++
				}
				if len(line)-1-x == y {
					matchesDiag[1]++
				}
				// fmt.Println(x, y, matchesDiag)
			}
			if matchesVertical[x] == len(line) {
				return true
			}
		}
		if matches == len(line) {
			return true
		}
	}
	// return matchesDiag[0] == len(board) || matchesDiag[1] == len(board)
	return false
}

func SumUnmarked(called map[int]bool, board [5][5]int) int {
	sum := 0
	for _, row := range board {
		for _, val := range row {
			if !called[val] {
				sum += val
			}
		}
	}
	return sum
}

func Part1(input string) []int {
	boards := StringToBoards(input)
	numsToCall := StringToBingo(input)
	calledNums := map[int]bool{}

	for _, num := range numsToCall {
		calledNums[num] = true
		for _, board := range boards {
			if WinningBoard(calledNums, board) {
				// fmt.Println("BINGO!", num, calledNums, board)
				sum := SumUnmarked(calledNums, board)
				// fmt.Println("Sum: ", sum, sum*num)
				return []int{sum, sum * num}
			}
		}
	}
	return []int{0, 0}
}

func Part2(input string) []int {
	boards := StringToBoards(input)
	numsToCall := StringToBingo(input)
	calledNums := map[int]bool{}
	winningBoards := map[int]bool{}

	for _, num := range numsToCall {
		calledNums[num] = true
		for i, board := range boards {
			if winningBoards[i] {
				continue
			}
			if WinningBoard(calledNums, board) {
				// fmt.Println("BINGO!", i, calledNums, board)
				winningBoards[i] = true
				// fmt.Println("Winning Boards: ", winningBoards)
				// fmt.Println("Lengths: ", len(winningBoards), len(boards)-1)
				if len(winningBoards) >= len(boards) {
					sum := SumUnmarked(calledNums, board)
					// fmt.Println("Sum: ", sum, num, sum*num)
					return []int{sum, sum * num}
				}
			}
		}
	}
	return []int{0, 0}
}
