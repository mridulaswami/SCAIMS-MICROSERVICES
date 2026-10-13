CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE public.roles (
                              id serial4 NOT NULL,
                              role_name varchar(50) NOT NULL,
                              description varchar(255) NULL,
                              created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
                              updated_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
                              CONSTRAINT roles_pkey PRIMARY KEY (id)
);


CREATE TABLE public.users (
                              id uuid DEFAULT gen_random_uuid() NOT NULL,
                              user_name varchar(255) NOT NULL,
                              "name" varchar(255) NOT NULL,
                              email varchar(255) NOT NULL,
                              "password" varchar(255) NOT NULL,
                              status bool DEFAULT true NULL,
                              created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
                              updated_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
                              ward_assigned varchar(100) NULL,
                              phone_number varchar(10) NULL,
                              is_first_time bool DEFAULT true NOT NULL,
                              CONSTRAINT users_email_key UNIQUE (email),
                              CONSTRAINT users_pkey PRIMARY KEY (id),
                              CONSTRAINT users_user_name_key UNIQUE (user_name)
);

CREATE TABLE public.user_roles (
                                   id uuid DEFAULT gen_random_uuid() NOT NULL,
                                   user_id uuid NOT NULL,
                                   role_id int4 NOT NULL,
                                   CONSTRAINT uk_user_role UNIQUE (user_id, role_id),
                                   CONSTRAINT user_roles_pkey PRIMARY KEY (id)
);


-- public.user_roles foreign keys

ALTER TABLE public.user_roles ADD CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES public.roles(id);
ALTER TABLE public.user_roles ADD CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

CREATE TABLE public.auths (
                              id uuid DEFAULT gen_random_uuid() NOT NULL,
                              access_token text NOT NULL,
                              refresh_token text NOT NULL,
                              access_token_expire_at timestamp NOT NULL,
                              refresh_token_expire_at timestamp NOT NULL,
                              user_id uuid NOT NULL,
                              created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
                              updated_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
                              CONSTRAINT auths_pkey PRIMARY KEY (id)
);


-- public.auths foreign keys

ALTER TABLE public.auths ADD CONSTRAINT fk_auths_user FOREIGN KEY (user_id) REFERENCES public.users(id);



CREATE TABLE public.otps (
                             id uuid DEFAULT gen_random_uuid() NOT NULL,
                             email varchar(255) NOT NULL,
                             otp varchar(10) NOT NULL,
                             expired_at timestamp NOT NULL,
                             created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
                             updated_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
                             CONSTRAINT otps_pkey PRIMARY KEY (id)
);


CREATE TABLE public.notifications (
                                      id uuid DEFAULT gen_random_uuid() NOT NULL,
                                      recipient_id uuid NOT NULL,
                                      actor_id uuid NULL,
                                      title varchar(255) NOT NULL,
                                      message text NOT NULL,
                                      "type" varchar(64) NOT NULL,
                                      priority varchar(32) DEFAULT 'MEDIUM'::character varying NOT NULL,
                                      target_type varchar(64) NULL,
                                      target_id varchar(128) NULL,
                                      is_read bool DEFAULT false NOT NULL,
                                      read_at timestamp NULL,
                                      created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
                                      CONSTRAINT notifications_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_notifications_recipient_created_at ON public.notifications USING btree (recipient_id, created_at DESC);
CREATE INDEX idx_notifications_recipient_is_read ON public.notifications USING btree (recipient_id, is_read);


-- public.notifications foreign keys

ALTER TABLE public.notifications ADD CONSTRAINT fk_notifications_actor FOREIGN KEY (actor_id) REFERENCES public.users(id) ON DELETE SET NULL;
ALTER TABLE public.notifications ADD CONSTRAINT fk_notifications_recipient FOREIGN KEY (recipient_id) REFERENCES public.users(id) ON DELETE CASCADE;


