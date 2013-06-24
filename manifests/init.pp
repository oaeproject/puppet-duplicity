define duplicity(
  $directory,
  $bucket = undef,
  $dest_id = undef,
  $dest_key = undef,
  $folder = undef,
  $cloud = undef,
  $pubkey_id = undef,
  $hour = undef,
  $minute = undef,
  $backup_script_file = undef,
  $backup_script_path = undef,
  $mail_to = undef,
  $mail_from = undef,
  $mail_tmp_mailbody = undef,
  $mail_tmp_message = undef,
  $mail_subject_success = undef,
  $mail_subject_error = undef,
  $full_if_older_than = undef,
  $pre_command = undef,
  $remove_older_than = undef
) {

  include duplicity::params
  include duplicity::packages

  $_bucket = $bucket ? {
    undef => $duplicity::params::bucket,
    default => $bucket
  }

  $_dest_id = $dest_id ? {
    undef => $duplicity::params::dest_id,
    default => $dest_id
  }

  $_dest_key = $dest_key ? {
    undef => $duplicity::params::dest_key,
    default => $dest_key
  }

  $_folder = $folder ? {
    undef => $duplicity::params::folder,
    default => $folder
  }

  $_cloud = $cloud ? {
    undef => $duplicity::params::cloud,
    default => $cloud
  }

  $_pubkey_id = $pubkey_id ? {
    undef => $duplicity::params::pubkey_id,
    default => $pubkey_id
  }

  $_hour = $hour ? {
    undef => $duplicity::params::hour,
    default => $hour
  }

  $_minute = $minute ? {
    undef => $duplicity::params::minute,
    default => $minute
  }

  $_backup_script_file = $backup_script_file ? {
    undef => $duplicity::params::backup_script_file,
    default => $backup_script_file
  }

  $_backup_script_path = $backup_script_path ? {
    undef => $duplicity::params::backup_script_path,
    default => $backup_script_path
  }

  $_mail_to = $mail_to ? {
    undef => $duplicity::params::mail_to,
    default => $mail_to
  }

  $_mail_from = $mail_from ? {
    undef => $duplicity::params::mail_from,
    default => $mail_from
  }

  $_mail_tmp_mailbody = $mail_tmp_mailbody ? {
    undef => $duplicity::params::mail_tmp_mailbody,
    default => $mail_tmp_mailbody
  }

  $_mail_tmp_message = $mail_tmp_message ? {
    undef => $duplicity::params::mail_tmp_message,
    default => $mail_tmp_message
  }

  $_mail_subject_success = $mail_subject_success ? {
    undef => $duplicity::params::mail_subject_success,
    default => $mail_subject_success
  }

  $_mail_subject_error = $mail_subject_error ? {
    undef => $duplicity::params::mail_subject_error,
    default => $mail_subject_error
  }

  $_full_if_older_than = $full_if_older_than ? {
    undef => $duplicity::params::full_if_older_than,
    default => $full_if_older_than
  }

  $_pre_command = $pre_command ? {
    undef => '',
    default => "$pre_command && "
  }

  $_encryption = $_pubkey_id ? {
    undef => '--no-encryption',
    default => "--encrypt-key $_pubkey_id"
  }

  $_remove_older_than = $remove_older_than ? {
    undef   => $duplicity::params::remove_older_than,
    default => $remove_older_than,
  }

  if !($_cloud in [ 's3', 'cf' ]) {
    fail('$cloud required and at this time supports s3 for amazon s3 and cf for Rackspace cloud files')
  }

  if !$_bucket {
    fail('You need to define a container/bucket name!')
  }

  $_target_url = $_cloud ? {
    'cf' => "'cf+http://$_bucket'",
    's3' => "'s3+http://$_bucket/$_folder/$name/'"
  }

  $_remove_older_than_command = $_remove_older_than ? {
    undef => '',
    default => " && duplicity remove-older-than $_remove_older_than --s3-use-new-style $_encryption --force $_target_url >> $_mail_tmp_mailbody"
  }

  if (!$_dest_id or !$_dest_key) {
    fail("You need to set all of your key variables: dest_id, dest_key")
  }

  $environment = $_cloud ? {
    'cf' => ["CLOUDFILES_USERNAME='$_dest_id'", "CLOUDFILES_APIKEY='$_dest_key'", "PATH='$_backup_script_path'"],
    's3' => ["AWS_ACCESS_KEY_ID='$_dest_id'", "AWS_SECRET_ACCESS_KEY='$_dest_key'", "PATH='$_backup_script_path'"],
  }

  file { "${_backup_script_file}_${name}":
    path => $_backup_script_file,
    owner => root,
    group => root,
    mode => 744,
    content => template("duplicity/file-backup.sh.erb")
  }

  cron { $name :
    environment => $environment,
    command => $backup_script_file,
    user => 'root',
    minute => $_minute,
    hour => $_hour,
  }

  if $_pubkey_id {
    exec { 'duplicity-pgp':
      command => "gpg --keyserver subkeys.pgp.net --recv-keys $_pubkey_id",
      path    => "/usr/bin:/usr/sbin:/bin",
      unless  => "gpg --list-key $_pubkey_id"
    }
  }
}
