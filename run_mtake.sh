#!/usr/bin/env bash

if command -v nvidia-smi >/dev/null 2>&1; then
    NGPUS=$(nvidia-smi --list-gpus | wc -l)
else
    NGPUS=0
fi
echo "NGPUS: ${NGPUS}"
exit 0

# for macOS
if command -v gdate &> /dev/null
then
    DATE_CMD=gdate
else
    DATE_CMD=date
fi

START_TIME="$(${DATE_CMD} +%s)"
START_TIME_STR="$(${DATE_CMD} -d @${START_TIME} +%Y%m%d-%H%M%S)"
BASENAME="$(basename "${BASH_SOURCE}" .sh)"
HOSTNAME_S="$(hostname -s)"
LOGFILE="${BASENAME}-${START_TIME_STR}-${HOSTNAME_S}.log"
echo "XXX LOGFILE ${LOGFILE}" | tee -a ${LOGFILE}
echo "XXX DATETIME ${START_TIME_STR}" | tee -a ${LOGFILE}

LANGS=("en" "es" "fr" "ja")
MODELS=()
#MODELS+=("ibm-granite/granite-3.3-8b-instruct" "granite-3.1-8b-lab-v2_rev-2" "granite-3.1-8b-lab-v1" "microsoft/phi-4")
#MODELS+=("granite-3.3-8b-instruct-3epochs" "granite-3.1-8b-lab-v2_rev-2-3epochs" "granite-3.1-8b-lab-v1-3epochs")
#MODELS+=("granite-3.3-8b-instruct-teigaku-genzei-interp")
#MODELS+=("granite-3.3-8b-instruct-ibm-newsroom-d5-x100-interp" "granite-3.3-8b-instruct-ibm-newsroom-d5-x100")
#MODELS+=("granite-3.3-8b-instruct-jfe-technical-report_r5-interp" "granite-3.3-8b-instruct-jfe-technical-report_r5")
#MODELS+=("granite-4.0-tiny-prerelease-greylock-r250721a")
MODELS+=("granite-4.0-small-prerelease-greylock-r250721a")
#MODELS+=("mistralai/Mistral-Small-3.2-24B-Instruct-2506")

# @@@ahoaho XXX
#INPUT_DIR=./data
INPUT_DIR=./data_mtake

# @@@ahoaho XXX
# OUTPUT_DIR=./evaluations
OUTPUT_DIR=./evaluations_mtake
	
for l in "${LANGS[@]}"; do
    for m in "${MODELS[@]}"; do
	THIS_START_TIME="$(${DATE_CMD} +%s)"
	THIS_START_TIME_STR="$(${DATE_CMD} -d @${THIS_START_TIME} +%Y%m%d-%H%M%S)"
	echo "XXX THIS_DATETIME ${THIS_START_TIME_STR}" | tee -a ${LOGFILE}

	cmd="python evaluation_main.py --input_data=${INPUT_DIR}/${l}_input_data.jsonl --input_response_data=${INPUT_DIR}/${l}_input_response_data_${m//\//__}.jsonl --output_dir=${OUTPUT_DIR}/${l}_input_response_data_${m//\//__}"
	echo "$cmd" | tee -a ${LOGFILE}
	eval "$cmd" 2>&1 | tee -a ${LOGFILE}

	THIS_END_TIME="$(${DATE_CMD} +%s)"
	THIS_END_TIME_STR="$(${DATE_CMD} -d @${THIS_END_TIME} +%Y%m%d-%H%M%S)"
	echo "XXX THIS_DATETIME ${THIS_END_TIME_STR}" | tee -a ${LOGFILE}
	echo "XXX THIS_ELAPSED_SECS $((THIS_END_TIME - THIS_START_TIME))" | tee -a ${LOGFILE}
    done
done

END_TIME="$(${DATE_CMD} +%s)"
END_TIME_STR="$(${DATE_CMD} -d @${END_TIME} +%Y%m%d-%H%M%S)"
echo "XXX DATETIME ${END_TIME_STR}" | tee -a ${LOGFILE}
echo "XXX ELAPSED_SECS $((END_TIME - START_TIME))" | tee -a ${LOGFILE}
