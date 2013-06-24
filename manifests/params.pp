class duplicity::params(
  $bucket                = undef,
  $dest_id               = undef,
  $dest_key              = undef,
  $cloud                 = $duplicity::defaults::cloud,
  $pubkey_id             = undef,
  $hour                  = $duplicity::defaults::hour,
  $minute                = $duplicity::defaults::minute,
  $backup_script_file    = $duplicity::defaults::backup_script_file,
  $backup_script_path    = $duplicity::defaults::backup_script_path,
  $full_if_older_than    = $duplicity::defaults::full_if_older_than,
  $remove_older_than     = undef,
  $mail_to               = undef,
  $mail_from             = $duplicity::defaults::mail_from,
  $mail_tmp_mailbody     = $duplicity::defaults::mail_tmp_mailbody,
  $mail_tmp_message      = $duplicity::defaults::mail_tmp_message,
  $mail_subject_success  = undef,
  $mail_subject_error    = $duplicity::defaults::mail_subject_error

) inherits duplicity::defaults {
}
