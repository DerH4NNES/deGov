<?php
/**
 * @file
 * Enables modules and site configuration for the {{ profile }} profile.
 */

/**
 * Implements hook_install_tasks().
 */
function degov_profile_install_tasks($install_state){
  $tasks = array(
    'degov_module_setup' => array(
      'display_name' => t('Install deGov modules'),
      'type' => 'batch'
    ),
    'degov_theme_setup' => array(
      'display_name' => t('Install deGov theme'),
      'display' => TRUE,
    ),
    'degov_finalize_setup' => array(
      'display_name' => t('Finalize installation'),
      'type' => 'batch',
      'display' => TRUE,
    ),
  );

  return $tasks;
}

/**
 * Install deGov modules task.
 */
function degov_module_setup(&$install_state) {
  drupal_get_messages('status', TRUE);

  $files = system_rebuild_module_data();

  $modules = array(
    'degov_userroles' => 'degov_userroles',
    'degov_rich_text_format_settings' => 'degov_rich_text_format_settings',
    'degov_plain_text_format_settings' => 'degov_plain_text_format_settings',
    'degov_pathauto' => 'degov_pathauto',
    'degov_metatags' => 'degov_metatags',
    'degov_tags' => 'degov_tags',
    'degov_easy_breadcrumb' => 'degov_easy_breadcrumb',
    'degov_cronconfig' => 'degov_cronconfig',
    'degov_scheduled_updates' => 'degov_scheduled_updates',
    'degov_address_element' => 'degov_address_element',
    'degov_image_element' => 'degov_image_element',
    'degov_image_text_element' => 'degov_image_text_element',
    'degov_text_element' => 'degov_text_element',
    'degov_citation_element' => 'degov_citation_element',
    'degov_links_element' => 'degov_links_element',
    'degov_contact_element' => 'degov_contact_element',
    'degov_gallery_element' => 'degov_gallery_element',
    'degov_downloads_element' => 'degov_downloads_element',
    'degov_faq_element' => 'degov_faq_element',
    'degov_google_maps_element' => 'degov_google_maps_element',
    'degov_video_element' => 'degov_video_element'
  );

  $operations = array();
  foreach ($modules as $module) {
    $operations[] = array('_install_degov_module_batch', array(array($module), $module));
  }

  $batch = array(
    'operations' => $operations,
    'title' => t('Install deGov modules'),
    'error_message' => t('An error occured during deGov module installation.')
  );

  return $batch;
}

/**
 * Performs batch installation of deGov modules.
 */
function _install_degov_module_batch($module, $module_name, &$context) {
  set_time_limit(0);
  \Drupal::service('module_installer')->install($module, $dependencies = TRUE);
  $context['results'][] = $module;
  $context['message'] = t('Install %module_name module.', array('%module_name' => $module_name));
}

/**
 * Install deGov theme task.
 */
function degov_theme_setup(&$install_state) {
  drupal_get_messages('status', TRUE);

  $theme = 'degov_theme';

  \Drupal::service('theme_handler')->install(array($theme));

  \Drupal::configFactory()
    ->getEditable('system.theme')
    ->set('default', $theme)
    ->save();

  \Drupal::service('theme.manager')->resetActiveTheme();

}

/**
 * Finalize deGov profile installation task.
 */
function degov_finalize_setup() {
  drupal_get_messages('status', TRUE);

  $batch = array();

  $degov_optional_modules = \Drupal::state()->get('degov_optional_modules');
  foreach ($degov_optional_modules as $module => $module_name) {
    $batch['operations'][] = ['_install_degov_module_batch', array(array($module), $module_name)];
  }

  return $batch;
}

/**
 * Implements hook_form_FORM_ID_alter().
 */
function degov_profile_form_install_configure_form_alter(&$form, \Drupal\Core\Form\FormStateInterface $form_state) {
  drupal_get_messages('status', TRUE);

  $degov_optional_modules = [
    'degov_eu_cookie_compliance' => t('EU cookie compliance'),
    'degov_password_policy' => t('Secure password policy'),
    'degov_sitemap' => t('User sitemap'),
    'degov_shariff_social_share' => t('Social sharing')
  ];

  $form['degov']['optional_modules'] = [
    '#type' => 'checkboxes',
    '#title' => t('ENABLE OPTIONAL FEATURES'),
    '#description' => t('Checked features are recommended.'),
    '#options' => $degov_optional_modules,
    '#default_value' => [
      'degov_eu_cookie_compliance',
      'degov_password_policy'
    ],
  ];

  $form['#submit'][] = 'degov_optional_modules_submit';
}

/**
 * Submit handler for degov_profile_form_install_configure_form_alter().
 */
function degov_optional_modules_submit($form_id, &$form_state) {
  $degov_optional_modules = array_filter($form_state->getValue('optional_modules'));
  \Drupal::state()->set('degov_optional_modules', $degov_optional_modules);
}
