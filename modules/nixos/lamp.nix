{
  config,
  pkgs,
  lib,
  ...
}: let
  phpPackage = pkgs.php.buildEnv {
    extensions = {
      enabled,
      all,
    }:
      enabled
      ++ (with all; [
        mysqli
        pdo
        pdo_mysql
        mbstring
        curl
        gd
        zip
        opcache
      ]);
    extraConfig = ''
      date.timezone = "UTC"
      upload_max_filesize = 64M
      post_max_size = 64M

      ; Error reporting
      display_errors = On
      display_startup_errors = On
      error_reporting = E_ALL & ~E_DEPRECATED & ~E_NOTICE
      log_errors = On
      error_log = /var/log/php_errors.log
    '';
  };

  pmaConfig = pkgs.writeText "config.inc.php" ''
    <?php
    $cfg['blowfish_secret'] = 'a8b3c7d2e1f4g5h6i7j8k9l0m1n2o3p4';
    $i = 1;
    $cfg['Servers'][$i]['auth_type']       = 'cookie';
    $cfg['Servers'][$i]['host']            = 'localhost';
    $cfg['Servers'][$i]['compress']        = false;
    $cfg['Servers'][$i]['AllowNoPassword'] = true;
    $cfg['UploadDir'] = "";
    $cfg['SaveDir']   = "";
  '';

  phpMyAdmin = pkgs.stdenv.mkDerivation rec {
    pname = "phpmyadmin";
    version = "5.2.1";
    src = pkgs.fetchurl {
      url = "https://files.phpmyadmin.net/phpMyAdmin/${version}/phpMyAdmin-${version}-all-languages.tar.gz";
      sha256 = "0ihw903irgdyyfz773pp8kkvqdjfbfvfmh54jrfinzc117r67iv1";
    };
    installPhase = ''
      mkdir -p $out
      cp -r * $out/
      ln -sf ${pmaConfig} $out/config.inc.php
    '';
  };
in {
  # ── PHP-FPM ────────────────────────────────────────────────────────────────
  services.phpfpm.pools.www = {
    user = "wwwrun";
    group = "wwwrun";
    phpPackage = phpPackage;
    settings = {
      "listen.owner" = config.services.httpd.user;
      "listen.group" = config.services.httpd.group;
      "pm" = "dynamic";
      "pm.max_children" = 10;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
    };
  };

  # ── Apache ─────────────────────────────────────────────────────────────────
  services.httpd = {
    enable = true;
    user = "wwwrun";
    group = "wwwrun";
    adminAddr = "admin@localhost";
    logFormat = "combined";

    extraModules = ["proxy_fcgi"];

    virtualHosts."localhost" = {
      documentRoot = "/var/www/html";
      extraConfig = ''
        <Directory "/var/www/html">
          Options Indexes FollowSymLinks
          AllowOverride All
          Require all granted
          DirectoryIndex index.php index.html
        </Directory>

        <FilesMatch "\.php$">
          SetHandler "proxy:unix:${config.services.phpfpm.pools.www.socket}|fcgi://localhost"
        </FilesMatch>

        LogLevel warn
        ErrorLog /var/log/httpd/error.log
        CustomLog /var/log/httpd/access.log combined
      '';
    };

    virtualHosts."phpmyadmin" = {
      listen = [{port = 8080;}];
      documentRoot = "${phpMyAdmin}";
      extraConfig = ''
        <Directory "${phpMyAdmin}">
          Options Indexes FollowSymLinks
          AllowOverride All
          Require all granted
          DirectoryIndex index.php

          <FilesMatch "\.php$">
            SetHandler "proxy:unix:${config.services.phpfpm.pools.www.socket}|fcgi://localhost"
          </FilesMatch>
        </Directory>

        LogLevel warn
        ErrorLog /var/log/httpd/phpmyadmin_error.log
        CustomLog /var/log/httpd/phpmyadmin_access.log combined
      '';
    };
  };

  # ── MariaDB ────────────────────────────────────────────────────────────────
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;

    settings.mysqld = {
      bind-address = "127.0.0.1";
      character-set-server = "utf8mb4";
      collation-server = "utf8mb4_unicode_ci";
    };

    initialScript = pkgs.writeText "mariadb-init.sql" ''
      CREATE DATABASE IF NOT EXISTS devdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
      CREATE USER IF NOT EXISTS 'devuser'@'localhost' IDENTIFIED BY 'devpass';
      GRANT ALL PRIVILEGES ON devdb.* TO 'devuser'@'localhost';

      ALTER USER 'root'@'localhost' IDENTIFIED BY "";
      GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
      FLUSH PRIVILEGES;
    '';
  };

  # ── Firewall ───────────────────────────────────────────────────────────────
  networking.firewall.allowedTCPPorts = [80 8080];

  # ── Web root ───────────────────────────────────────────────────────────────
  systemd.tmpfiles.rules = [
    "d /var/www/html 0755 wwwrun wwwrun -"
  ];

  # ── Packages ───────────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    phpPackage
    phpPackage.packages.composer
    mariadb
  ];
}
