#! /usr/bin/env sh

. "${NUMONIC_HOME}/sh/scripts/import-userenv"

test_cmd="userenv-prepend"
final=0

###
test_name="with_equals"
print-warn "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}.env

## act
if ! userenv prepend name=value --file="${__userenv_file}"; then
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
if ! userenv prepend name value --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

## assert
if ! grep '^name="value"$' "${__userenv_file}" 1>/dev/null; then
	print-fail "userenv-prepend: ${test_name} failed: name='value' not found"
	print-fail < "${__userenv_file}"
	final=1
fi

###
test_name="with_equals_with_quotes"
print-warn "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if ! userenv prepend name="value" --file="${__userenv_file}"; then
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
if ! userenv prepend name "value" --file="${__userenv_file}"; then
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
if ! userenv prepend existing="1" --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

if ! userenv prepend existing="2" --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

## assert
if ! grep '^existing="2:1"$' "${__userenv_file}" 1>/dev/null; then
	print-fail "${test_cmd}: ${test_name} failed: existing='2:1' not found"
	print-fail < "${__userenv_file}"
	final=1
fi

###
test_name="with_custom_separator"
print-warn "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if ! userenv prepend existing="1" -s '!' --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

if ! userenv prepend existing="2" --separator='!' --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

## assert
if ! grep '^existing="2!1"$' "${__userenv_file}" 1>/dev/null; then
	print-fail "${test_cmd}: ${test_name} failed: existing='2!1' not found"
	print-fail < "${__userenv_file}"
	final=1
fi

###
test_name="with_help"
print-warn "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if ! userenv prepend --help --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

###
test_name="with_dry_run"
print-warn "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if ! userenv prepend name "value" --dry-run --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

if ! userenv prepend name "value" -dr --file="${__userenv_file}"; then
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
if userenv prepend name value extra --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?, but should have been 1"
fi

###
test_name="with_missing_value"
print-warn "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if userenv prepend name --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?, but should have been 1"
fi

###
test_name="with_missing_name"
print-warn "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if userenv prepend --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?, but should have been 1"
fi

return ${final}
