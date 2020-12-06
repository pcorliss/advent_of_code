# Advent of Code 2020

My solutions to https://adventofcode.com/2020

## Templates

```
cp -pr blank 06
cd 06
find . | grep rb | xargs sed -i 's/blank/<challenge>/g'
find . | grep rb | xargs sed -i 's/Blank/<day>/g'
mv blank.rb customs.rb
mv spec/blank_spec.rb spec/customs_spec.rb
```
