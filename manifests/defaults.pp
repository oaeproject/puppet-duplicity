class duplicity::defaults {
  $excludes = []
  $folder = $::fqdn
  $cloud = 's3'
  $hour = 0
  $minute = 0
  $backup_script_file = '/opt/backup-cron.sh'
  $backup_script_path = '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
  $full_if_older_than = '30D'
  $mail_from = "backup@$::hostname"
  $mail_tmp_mailbody = '/tmp/mailbody.txt'
  $mail_tmp_message = '/tmp/message.html'
  $mail_subject_success = undef
  $mail_subject_error = '[backup] Error performing backup'
}
