package main

import (
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("07/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 07")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
}

func StringToNums(input string) []int {
	nums := []int{}
	lines := strings.Split(input, ",")
	for _, val := range lines {
		n, err := strconv.Atoi(val)
		if err != nil {
			panic(err)
		}
		nums = append(nums, n)
	}
	return nums
}

// https://guilherme-ferreira.me/internet-and-inovation/go-lang/calculating-mean-and-median-using-go/
func CalcMedian(nums []int) int {
	sort.Ints(nums) // sort the numbers

	mNumber := len(nums) / 2

	if mNumber%2 == 1 {
		return nums[mNumber]
	}

	return (nums[mNumber-1] + nums[mNumber]) / 2
}

func CalcAvg(nums []int) int {
	sum := 0
	for _, val := range nums {
		sum += val
	}
	return sum/len(nums) + 1
}

func MinMax(nums []int) []int {
	min := 0
	max := 0

	for i, n := range nums {
		if n < min || i == 0 {
			min = n
		}
		if n > max || i == 0 {
			max = n
		}
	}

	return []int{min, max}
}

func Part1(input string) []int {
	nums := StringToNums(input)
	med := CalcMedian(nums)

	fuel := 0
	for _, n := range nums {
		diff := n - med
		if diff < 0 {
			diff *= -1
		}
		fuel += diff
	}

	return []int{med, fuel}
}

func FuelCost(n int) int {
	return n * (n + 1) / 2
}

func PointFuelCost(point int, nums []int) int {
	fuel := 0
	for _, n := range nums {
		diff := n - point
		if diff < 0 {
			diff *= -1
		}
		fuel += FuelCost(diff)
	}
	return fuel
}

// Answer is too high
// Result:  [448 88612611]
func Part2FirstAttempt(input string) []int {
	nums := StringToNums(input)
	avg := CalcAvg(nums)

	fuel := 0
	for _, n := range nums {
		diff := n - avg
		if diff < 0 {
			diff *= -1
		}
		// 1, 2, 3, 4, 5
		// 1, 3, 6, 10, 15
		fuel += FuelCost(diff)
	}

	return []int{avg, fuel}
}

// Answer is too high
// Result:  [448 88612611]
// Correct Answer
// Result: [447 88612508]
func Part2SlowButWorkingAttempt(input string) []int {
	nums := StringToNums(input)
	avg := CalcAvg(nums)
	minMax := MinMax(nums)
	min, max := minMax[0], minMax[1]

	minFuel := -1
	minPoint := -1

	for point := min; point <= max; point++ {
		fuel := 0
		for _, n := range nums {
			diff := n - point
			if diff < 0 {
				diff *= -1
			}
			// 1, 2, 3, 4, 5
			// 1, 3, 6, 10, 15
			fuel += FuelCost(diff)
		}
		if minFuel == -1 || fuel < minFuel {
			minFuel = fuel
			minPoint = point
			// fmt.Println("New Min: ", minFuel, point)
		} else {
			// fmt.Println("Fuel is increasing:", point)
			return []int{minPoint, minFuel}
		}
	}

	return []int{avg, minFuel}
}

// Fast Attempt
// Could add some memoization here as well
func Part2Fast(input string) []int {
	nums := StringToNums(input)
	start := CalcAvg(nums)

	minFuel := PointFuelCost(start, nums)
	minPoint := start
	// lastFuel := start

	for {
		// fmt.Println("Min:", minPoint, minFuel)
		cost_low := PointFuelCost(minPoint-1, nums)
		cost_high := PointFuelCost(minPoint+1, nums)
		if cost_low >= minFuel && cost_high >= minFuel {
			break
		}
		if cost_low < minFuel {
			// fmt.Println("Low:", minPoint-1, cost_low)
			minFuel = cost_low
			minPoint--
		}
		if cost_high < minFuel {
			// fmt.Println("High:", minPoint+1, cost_high)
			minFuel = cost_high
			minPoint++
		}

	}

	return []int{minPoint, minFuel}
}

// Use the average properly
// This should be the fastest
func Part2(input string) []int {
	nums := StringToNums(input)
	avg := CalcAvg(nums)

	aFuel := PointFuelCost(avg, nums)
	bFuel := PointFuelCost(avg-1, nums)

	if aFuel > bFuel {
		return []int{avg - 1, bFuel}
	}
	return []int{avg, aFuel}
}
