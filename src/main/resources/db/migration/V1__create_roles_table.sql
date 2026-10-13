CREATE EXTENSION IF NOT EXISTS "pgcrypto";
       CREATE EXTENSION IF NOT EXISTS postgis;


CREATE TABLE public.complaint (
                                  id uuid DEFAULT gen_random_uuid() NOT NULL,
                                  citizen_id uuid NOT NULL,
                                  description varchar(200) NULL,
                                  "location" public.geometry(point, 4326) NOT NULL,
                                  status varchar(200) DEFAULT 'SUBMITTED'::character varying NULL,
                                  linked_work_order_id uuid NULL,
                                  title varchar(255) NULL,
                                  asset_id uuid NULL,
                                  created_at timestamp NULL,
                                  updated_at timestamp NULL,
                                  pid varchar(255) NULL,
                                  CONSTRAINT complaint_pkey PRIMARY KEY (id)
);


-- public.complaint foreign keys


CREATE TABLE public.complaint_photo (
                                        id uuid DEFAULT gen_random_uuid() NOT NULL,
                                        complaint_id uuid NOT NULL,
                                        photo_url varchar(500) NOT NULL,
                                        CONSTRAINT complaint_photo_pkey PRIMARY KEY (id)
);


-- public.complaint_photo foreign keys

ALTER TABLE public.complaint_photo ADD CONSTRAINT fk_complaint_photo_complaint FOREIGN KEY (complaint_id) REFERENCES public.complaint(id) ON DELETE CASCADE;

CREATE TABLE public.complaint_status_audits (
                                                id uuid NOT NULL,
                                                previous_status varchar(50) NOT NULL,
                                                current_status varchar(50) NOT NULL,
                                                change_at timestamp NOT NULL,
                                                changed_by uuid NOT NULL,
                                                created_at timestamp NOT NULL,
                                                updated_at timestamp NOT NULL,
                                                complaint_id uuid NOT NULL,
                                                CONSTRAINT pk_complaint_status_audits PRIMARY KEY (id)
);
CREATE INDEX idx_complaint_status_audits_change_at ON public.complaint_status_audits USING btree (change_at);
CREATE INDEX idx_complaint_status_audits_changed_by ON public.complaint_status_audits USING btree (changed_by);
CREATE INDEX idx_complaint_status_audits_complaint_id ON public.complaint_status_audits USING btree (complaint_id);


-- public.complaint_status_audits foreign keys

ALTER TABLE public.complaint_status_audits ADD CONSTRAINT fk_complaint_status_audits_complaint FOREIGN KEY (complaint_id) REFERENCES public.complaint(id);


CREATE TABLE public.work_order (
                                   id uuid DEFAULT gen_random_uuid() NOT NULL,
                                   priority varchar(20) NULL,
                                   status varchar(20) NULL,
                                   due_date timestamp NULL,
                                   created_at timestamp NULL,
                                   closed_at timestamp NULL,
                                   complaint_id uuid NULL,
                                   user_id uuid NULL,
                                   work_report text NULL,
                                   rejection_reason varchar(255) NULL,
                                   created_by uuid NULL,
                                   CONSTRAINT work_order_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_work_order_complaint_id ON public.work_order USING btree (complaint_id);
CREATE INDEX idx_work_order_user_id ON public.work_order USING btree (user_id);


-- public.work_order foreign keys

ALTER TABLE public.work_order ADD CONSTRAINT fk_work_order_complaint FOREIGN KEY (complaint_id) REFERENCES public.complaint(id);

CREATE TABLE public.work_order_photo (
                                         id uuid DEFAULT gen_random_uuid() NOT NULL,
                                         work_order_id uuid NOT NULL,
                                         photo_url varchar(500) NOT NULL,
                                         created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
                                         updated_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
                                         CONSTRAINT work_order_photo_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_work_order_photo_work_order_id ON public.work_order_photo USING btree (work_order_id);


-- public.work_order_photo foreign keys

ALTER TABLE public.work_order_photo ADD CONSTRAINT fk_work_order_photo_work_order FOREIGN KEY (work_order_id) REFERENCES public.work_order(id) ON DELETE CASCADE;

CREATE TABLE public.work_order_status_audits (
                                                 id uuid NOT NULL,
                                                 previous_status varchar(50) NOT NULL,
                                                 current_status varchar(50) NOT NULL,
                                                 change_at timestamp NOT NULL,
                                                 changed_by uuid NOT NULL,
                                                 created_at timestamp NOT NULL,
                                                 updated_at timestamp NOT NULL,
                                                 work_order_id uuid NOT NULL,
                                                 CONSTRAINT pk_work_order_status_audits PRIMARY KEY (id)
);
CREATE INDEX idx_work_order_status_audits_change_at ON public.work_order_status_audits USING btree (change_at);
CREATE INDEX idx_work_order_status_audits_changed_by ON public.work_order_status_audits USING btree (changed_by);
CREATE INDEX idx_work_order_status_audits_work_order_id ON public.work_order_status_audits USING btree (work_order_id);


-- public.work_order_status_audits foreign keys

ALTER TABLE public.work_order_status_audits ADD CONSTRAINT fk_work_order_status_audits_work_order FOREIGN KEY (work_order_id) REFERENCES public.work_order(id);