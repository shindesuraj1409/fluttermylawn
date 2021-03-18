#!/bin/sh
# Run integration tests

helpFunction()
{
   echo ""
   echo "Usage: $0 -d (android/ios) -k (\"--dart-define=<KEY_NAME=VALUE>...\") \nExample: ./automation-integration-test.sh -d ios -k \"--dart-define=RC_KEY=515e4f5e4f5e1fe21fe5f1e451f85e --dart-define=GMAPS_KEY=16541f56sd1f65sd1f6s51f6s51f56s1\" -e rc"
   echo -d "\tSet device os android/ios"
   echo -k "\tSet additional application API keys inside double quotes (\"--dart-define=<KEY_NAME=VALUE>...\")"
   echo -e "\tSet application environment (rc, dev, hotfix, prod) default is \"rc\""
   exit 1 # Exit script after printing help
}

# Test group array
selected_test_groups=(0);

setupTestGroupFunction()
{
   echo "Select test groups:"
   echo "0. All Groups"
   echo "1. UAT Primary tests"
   echo "2. UAT Secondary tests"
   echo "3. Full Functionality Basic tests"
   echo "4. Full Functionality Subscription tests"
   echo "5. Full Functionality Product Listing tests"
   echo "6. Full Functionality Profile tests"
   echo "7. Full Functionality Lawn Task tests"
   echo "8. Full Functionality Auth tests"
   echo "9. Full Deeplink tests"
   echo "------------------------------------------------------------------------------------------"
   echo "You can select multiple test group by entering test group code with space e.g. 2 3 4"
   read -p "Select: " -ra a;

   if [ "${a}" == "0" ]; then
     selected_test_groups=(1 2 3 4 5 6 7 8 9)
    else
      selected_test_groups=${a[@]}
   fi
}

# Set default environment
environmentType="rc"

while getopts "d:k:e:" opt
do
   case "$opt" in
      d ) deviceOs="$OPTARG" ;;
      k ) additionalKeys="$OPTARG" ;;
      e ) environmentType="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$deviceOs" ] || [ -z "$additionalKeys" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
else
   setupTestGroupFunction
fi

clearCache(){
    if [ $deviceOs == "android" ]; then
        adb shell pm clear com.scotts.lawnapp
    else
        SIM=$(xcrun simctl list | grep Booted)
        echo "Read sim: ${SIM}"

        if [$SIM == ""]; then
            echo "We got a real ios device :)"
            ios_app_installer -b com.scotts.lawnapp -u
        else
            echo "We are working with ios sims :("
            xcrun simctl uninstall booted com.scotts.lawnapp
        fi
    fi
}

# Check if the reports folder exists and delete
REPORTS_DIR="test_driver/reports"

if [ -d "$REPORTS_DIR" ]; then
    rm -rf $REPORTS_DIR
fi

# Create reports folder
mkdir $REPORTS_DIR

# Created a test groups for the 5-5 tests
# 11 tests
uat_test_group='
cancel_and_retake_quiz_new_subscription
complete_quiz_login_with_existing_user
add_non_restricted_product
create_account_reset_pass
verify_faq
add_note_with_attachment
add_an_overseed_task
add_a_lawn_mowing_task
lawn_tip_article
sprinkler_zip_preferences
sprinkler_info
guest_sprinkler_info
edit_account_info
'

# 5 tests
uat_smoke_test_group='
annual_subscription_with_addon
annual_subscription_skip_a_shipment
seasonal_sub_with_addon
subscription_flow_with_create_account
cancel_seasonal_sub_without_addon
'

# 11 tests
full_functionality_basic_test_group='
splash_screen
welcome_screen
lawn_condition_screen
spreader_screen
manual_entry_screen
lawn_size_screen
grass_types_screen
verify_grass_types_for_each_zone
lawn_quiz_backward_navigation_and_check_progress_bar
fab_home_screen
ask_screen_elements
user_sees_home_screen
user_sees_product_detail_screen
guest_user_home_screen
guest_user_product_detail_screen
tool_tip_quiz_screens
product_buy_online
'

# 4 tests
full_functionality_subscription_test_group='
annual_subscription_without_addon
seasonal_sub_without_addon
cancel_annual_subscription
my_subscription
customize_plan_add_a_product_manually
seasonal_subscription_skip_a_shipment
create_and_skip_seasonal_subscription
'

# 15 tests
full_functionality_product_listing_test_group='
product_listing_page_main_screen
product_listing_page_need_help_with_finding_products
product_listing_page_cancel_search
product_listing_page_search_a_product
product_listing_page_filter_clearall_main_category
product_listing_page_filter_clearall_lawn_goals
product_listing_page_filter_clearall_lawn_problems
product_listing_page_no_results_found_search
product_listing_page_filter_selectall_main_category
product_listing_page_filter_selectall_lawn_problems
product_listing_page_filter_selectall_lawn_goals
product_listing_page_with_pre_filtered_user_region
product_listing_page_to_product_detail_page_lawn_goals
product_listing_page_to_product_detail_page_lawn_problem
product_listing_page_to_product_detail_page_main_category
'

# 4 tests
full_functionality_profile_test_group='
edit_lawn_profile
settings_screen
guest_user_signs_up_with_new_scotts_account_from_profile
guest_user_signs_up_with_existing_scotts_account_from_profile
retake_lawn_quiz_with_same_answers
profile
edit_lawn_profile_unsubscribed_user
'

# 3 tests
full_functionality_lawn_task_test_group='
add_a_water_task
edit_a_water_task_today
edit_a_water_task_to_future
add_task_guest_user
add_note_guest_user
verify_other_task
'

# 4 tests
full_functionality_auth_test_group='
take_quiz_and_sign_up_with_new_account
take_quiz_and_sign_up_with_existing_account
sign_up_screen
login_with_scotts_account
log_out
'

# 31 tests
full_deeplink_test_group='
deeplinks_appsetting_aboutmylawnapp
deeplinks_appsettings
deeplinks_ask
deeplinks_calendar
deeplinks_faq_article
deeplinks_feedseedactivities
deeplinks_grassseeds
deeplinks_guest_signup
deeplinks_home
deeplinks_insectdiseasecontrol
deeplinks_lawnfood
deeplinks_mylawncareplan
deeplinks_mysubscriptionscreen
deeplinks_note
deeplinks_pdp_product
deeplinks_plp
deeplinks_profile
deeplinks_rainfalltotal
deeplinks_signup
deeplinks_task
deeplinks_task_aeratelawn
deeplinks_task_clean_deck
deeplinks_task_dethatchlawn
deeplinks_task_mowing
deeplinks_task_mulch_beds
deeplinks_task_overseed_lawn
deeplinks_task_tuneupmower
deeplinks_task_water
deeplinks_task_winterizesprinkler
deeplinks_tips
deeplinks_tips_article
deeplinks_weedcontrol
'

# install imapclient
pip3 install imapclient

setup_test_build(){
  additionalKeys+=" --dart-define=TEST_ENV=${environmentType}"
  if [ $2 -eq 9 ]; then
  flutter drive --target=test_driver/deeplinks/$1.dart --dart-define=FLUTTER_DRIVER_OS=$deviceOs $additionalKeys | tee $REPORTS_DIR/$1.txt
  else
  flutter drive --target=test_driver/tests/$1.dart --dart-define=FLUTTER_DRIVER_OS=$deviceOs $additionalKeys | tee $REPORTS_DIR/$1.txt
  fi
}

run_tests(){
    if [ $2 -eq 9 ]; then
    flutter drive --target=test_driver/deeplinks/$1.dart --no-build --no-pub 2>&1 | tee $REPORTS_DIR/$1.txt
    else
    flutter drive --target=test_driver/tests/$1.dart --no-build --no-pub 2>&1 | tee $REPORTS_DIR/$1.txt
    fi
}

# Setup test build flag
flag=1

# Temp array
active_test_list=();

# Create a array of all the test group
test_cases=("${uat_test_group}" "${uat_smoke_test_group}" "${full_functionality_basic_test_group}" "${full_functionality_subscription_test_group}" "${full_functionality_product_listing_test_group}" "${full_functionality_profile_test_group}" "${full_functionality_lawn_task_test_group}" "${full_functionality_auth_test_group}" "${full_deeplink_test_group}")
for selected_test_group_index in ${selected_test_groups[@]}; do
  sleep 5
  active_test_list[$(expr $selected_test_group_index - 1)]=${test_cases[$(expr $selected_test_group_index - 1)]}
  for test_group in ${test_cases[$(expr $selected_test_group_index - 1)]}; do
    for i in $test_group; do
      echo $i
      if [ $flag -eq 1 ]; then
        setup_test_build $i $selected_test_group_index
        flag=0
        continue
      fi
      run_tests $i $selected_test_group_index
    done
  done
done

python3 test_driver/utils/convertTxtToJson.py "${active_test_list[@]}"