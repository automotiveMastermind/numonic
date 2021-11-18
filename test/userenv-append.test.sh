#! /usr/bin/env sh

. "${NUMONIC_HOME}/sh/scripts/import-userenv"

test_cmd="userenv-append"
final=0

###
test_name="with_equals"
print-warn "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}.env

## act
if ! userenv append name=value --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

## assert
if ! grep '^name="value"$' "${__userenv_file}" 1>/dev/null; then
	print-fail "${test_cmd}: ${test_name} failed: name='value' not found"
	print-fail < "${__userenv_file}"
	final=1
fi

###
test_name="without_equals"
print-warn "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if ! userenv append name value --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

## assert
if ! grep '^name="value"$' "${__userenv_file}" 1>/dev/null; then
	print-fail "userenv-append: ${test_name} failed: name='value' not found"
	print-fail < "${__userenv_file}"
	final=1
fi

###
test_name="with_equals_with_quotes"
print-warn "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if ! userenv append name="value" --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

## assert
if ! grep '^name="value"$' "${__userenv_file}" 1>/dev/null; then
	print-fail "${test_cmd}: ${test_name} failed: name='value' not found"
	print-fail < "${__userenv_file}"
	final=1
fi

###
test_name="without_equals_with_quotes"
print-warn "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if ! userenv append name "value" --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

## assert
if ! grep '^name="value"$' "${__userenv_file}" 1>/dev/null; then
	print-fail "${test_cmd}: ${test_name} failed: name='value' not found"
	print-fail < "${__userenv_file}"
	final=1
fi

###
test_name="with_existing_values"
print-warn "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if ! userenv append existing="1" --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

if ! userenv append existing="2" --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

## assert
if ! grep '^existing="1:2"$' "${__userenv_file}" 1>/dev/null; then
	print-fail "${test_cmd}: ${test_name} failed: existing='1:2' not found"
	print-fail < "${__userenv_file}"
	final=1
fi

###
test_name="with_custom_separator"
print-warn "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if ! userenv append existing="1" -s '!' --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

if ! userenv append existing="2" --separator='!' --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

## assert
if ! grep '^existing="1!2"$' "${__userenv_file}" 1>/dev/null; then
	print-fail "${test_cmd}: ${test_name} failed: existing='1!2' not found"
	print-fail < "${__userenv_file}"
	final=1
fi

###
test_name="with_help"
print-warn "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if ! userenv append --help --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

###
test_name="with_dry_run"
print-warn "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if ! userenv append name "value" --dry-run --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

if ! userenv append name "value" -dr --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

## assert
if grep '^name="value"$' "${__userenv_file}" 1>/dev/null; then
	print-fail "${test_cmd}: ${test_name} failed: name='value' found; should be dry run"
	print-fail < "${__userenv_file}"
	final=1
fi

###
test_name="with_extra_arg"
print-warn "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if userenv append name value extra --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?, but should have been 1"
fi

###
test_name="with_missing_value"
print-warn "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if userenv append name --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?, but should have been 1"
fi

###
test_name="with_missing_name"
print-warn "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if userenv append --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?, but should have been 1"
fi

return ${final}
