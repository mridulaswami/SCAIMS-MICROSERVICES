CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE public.asset_category (
                                       id uuid DEFAULT gen_random_uuid() NOT NULL,
                                       "name" varchar(255) NOT NULL,
                                       icon_key varchar(255) NULL,
                                       default_layer_color varchar(255) NULL,
                                       CONSTRAINT asset_category_pkey PRIMARY KEY (id),
                                       CONSTRAINT uk_asset_category_name UNIQUE (name)
);


       CREATE TABLE public.assets (
                               id uuid DEFAULT gen_random_uuid() NOT NULL,
                               "name" varchar(255) NOT NULL,
                               category_id uuid NOT NULL,
                               geometry public.geometry(geometry, 4326) NOT NULL,
                               status varchar(50) NULL,
                               "condition" varchar(100) NULL,
                               ward varchar(100) NULL,
                               installed_date timestamp NULL,
                               last_inspected_date timestamp NULL,
                               parent_asset_id uuid NULL,
                               source_type varchar(20) NULL,
                               source_id int8 NULL,
                               CONSTRAINT assets_pkey PRIMARY KEY (id),
                               CONSTRAINT uq_assets_osm_source UNIQUE (source_type, source_id)
);
CREATE INDEX idx_assets_geometry ON public.assets USING gist (geometry);
CREATE INDEX idx_child_assets_parent ON public.assets USING btree (parent_asset_id);


-- public.assets foreign keys

ALTER TABLE public.assets ADD CONSTRAINT assets_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.asset_category(id);
ALTER TABLE public.assets ADD CONSTRAINT assets_parent_asset_id_fkey FOREIGN KEY (parent_asset_id) REFERENCES public.assets(id);
ALTER TABLE public.assets ADD CONSTRAINT fk_assets_parent_asset FOREIGN KEY (parent_asset_id) REFERENCES public.assets(id);


CREATE TABLE public.parent_assets (
                                      id uuid DEFAULT gen_random_uuid() NOT NULL,
                                      "name" varchar(255) NOT NULL,
                                      category_id uuid NOT NULL,
                                      geometry public.geometry(polygon, 4326) NOT NULL,
                                      status varchar(50) NULL,
                                      "condition" varchar(100) NULL,
                                      ward varchar(100) NULL,
                                      installed_date timestamp NULL,
                                      last_inspected_date timestamp NULL,
                                      CONSTRAINT parent_assets_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_parent_assets_geometry ON public.parent_assets USING gist (geometry);


-- public.parent_assets foreign keys

ALTER TABLE public.parent_assets ADD CONSTRAINT parent_assets_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.asset_category(id);



