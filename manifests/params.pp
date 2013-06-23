class duplicity::params(
  $bucket                = undef,
  $dest_id               = undef,
  $dest_key              = undef,
  $cloud                 = $duplicity::defaults::cloud,
  $pubkey_id             = undef,
  $hour                  = $duplicity::defaults::hour,
  $minute                = $duplicity::defaults::minute,
  $full_if_older_than    = $duplicity::defaults::full_if_older_than,
  $remove_older_than     = undef,
  $mail_to               = undef,
  $mail_from             = "backup@$::hostname",
  $mail_tmp_mailbody     = '/tmp/mailbody.txt',
  $mail_tmp_message      = '/tmp/message.html',
  $mail_subject_success  = undef
  $mail_subject_error    = '[backup] Error performing backup',

) inherits duplicity::defaults {
}
