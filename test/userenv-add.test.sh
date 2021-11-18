#! /usr/bin/env sh

. "${NUMONIC_HOME}/sh/scripts/import-userenv"

test_cmd="userenv-add"
final=0

###
test_name="with_equals"
print-success "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}.env

## act
if ! userenv add name=value --file="${__userenv_file}"; then
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
print-success "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if ! userenv add name value --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

## assert
if ! grep '^name="value"$' "${__userenv_file}" 1>/dev/null; then
	print-fail "userenv-add: ${test_name} failed: name='value' not found"
	print-fail < "${__userenv_file}"
	final=1
fi

###
test_name="with_equals_with_quotes"
print-success "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if ! userenv add name="value" --file="${__userenv_file}"; then
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
print-success "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if ! userenv add name "value" --file="${__userenv_file}"; then
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
print-success "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if ! userenv add existing="1" --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

if ! userenv add new="2" --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

## assert
if ! grep '^existing="1"$' "${__userenv_file}" 1>/dev/null; then
	print-fail "${test_cmd}: ${test_name} failed: existing='1' not found"
	print-fail < "${__userenv_file}"
	final=1
elif ! grep '^new="2"$' "${__userenv_file}" 1>/dev/null; then
	print-fail "${test_cmd}: ${test_name} failed: new='2' not found"
	print-fail < "${__userenv_file}"
	final=1
fi

###
test_name="with_dry_run"
print-success "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if ! userenv add name "value" --dry-run --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

if ! userenv add name "value" -dr --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

## assert
if grep '^name="value"$' "${__userenv_file}" 1>/dev/null; then
	print-fail "${test_cmd}: ${test_name} failed: name='value' found; should be dry run"
	print-fail < "${__userenv_file}"
	final=1
fi

###
test_name="with_help"
print-success "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if ! userenv add --help --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?"
fi

###
test_name="with_extra_arg"
print-success "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if userenv add name value extra --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?, but should have been 1"
fi

###
test_name="with_missing_value"
print-success "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if userenv add name --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?, but should have been 1"
fi

###
test_name="with_missing_name"
print-success "${test_cmd}: ${test_name}"

## arrange
__userenv_file=${test_name}

## act
if userenv add --file="${__userenv_file}"; then
	print-fail "${test_cmd}: ${test_name} failed: exit code $?, but should have been 1"
fi

return ${final}
