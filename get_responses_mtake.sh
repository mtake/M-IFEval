#!/usr/bin/env bash

# Run on a Linux machine with GPU

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

declare -a MODELS=("granite-3.1-8b-lab-v1" "granite-3.1-8b-lab-v1-3epochs" "granite-3.1-8b-lab-v2_rev-2" "granite-3.1-8b-lab-v2_rev-2-3epochs" "ibm-granite/granite-3.3-8b-instruct" "granite-3.3-8b-instruct-3epochs")

for m in "${MODELS[@]}"; do
    THIS_START_TIME="$(${DATE_CMD} +%s)"
    THIS_START_TIME_STR="$(${DATE_CMD} -d @${THIS_START_TIME} +%Y%m%d-%H%M%S)"
    echo "XXX THIS_DATETIME ${THIS_START_TIME_STR}" | tee -a ${LOGFILE}

    # @@@ahoaho XXX
    # cmd="python get_responses.py --model_name ${m}"
    cmd="python get_responses_mtake.py --model_name ${m}"
    echo "$cmd" | tee -a ${LOGFILE}
    eval "$cmd" 2>&1 | tee -a ${LOGFILE}

    THIS_END_TIME="$(${DATE_CMD} +%s)"
    THIS_END_TIME_STR="$(${DATE_CMD} -d @${THIS_END_TIME} +%Y%m%d-%H%M%S)"
    echo "XXX THIS_DATETIME ${THIS_END_TIME_STR}" | tee -a ${LOGFILE}
    echo "XXX THIS_ELAPSED_SECS $((THIS_END_TIME - THIS_START_TIME))" | tee -a ${LOGFILE}
done

END_TIME="$(${DATE_CMD} +%s)"
END_TIME_STR="$(${DATE_CMD} -d @${END_TIME} +%Y%m%d-%H%M%S)"
echo "XXX DATETIME ${END_TIME_STR}" | tee -a ${LOGFILE}
echo "XXX ELAPSED_SECS $((END_TIME - START_TIME))" | tee -a ${LOGFILE}
