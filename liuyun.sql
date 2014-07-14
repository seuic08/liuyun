--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: handle_post_pans_change(); Type: FUNCTION; Schema: public; Owner: xiang
--

CREATE FUNCTION handle_post_pans_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
     IF (TG_OP = 'INSERT') THEN
     UPDATE posts SET pans = pans+1 WHERE id = NEW.post_id;
     ELSIF (TG_OP = 'DELETE') THEN
     UPDATE posts SET pans = pans-1 WHERE id = OLD.post_id;
     DELETE FROM pans WHERE id=OLD.pan_id AND NOT EXISTS (SELECT 1 FROM post_pans WHERE pan_id=OLD.pan_id);
     END IF;
     RETURN NULL;
END;
$$;


ALTER FUNCTION public.handle_post_pans_change() OWNER TO xiang;

--
-- Name: handle_posts_change(); Type: FUNCTION; Schema: public; Owner: xiang
--

CREATE FUNCTION handle_posts_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
     IF (TG_OP = 'INSERT') THEN
     UPDATE sites SET posts = posts+1 WHERE id = NEW.site_id;
     ELSIF (TG_OP = 'DELETE') THEN
     UPDATE sites SET posts = posts-1 WHERE id = OLD.site_id;
     END IF;
     RETURN NULL;
END;
$$;


ALTER FUNCTION public.handle_posts_change() OWNER TO xiang;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: pans; Type: TABLE; Schema: public; Owner: xiang; Tablespace: 
--

CREATE TABLE pans (
    id integer NOT NULL,
    link text NOT NULL,
    clicked integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.pans OWNER TO xiang;

--
-- Name: pans_id_seq; Type: SEQUENCE; Schema: public; Owner: xiang
--

CREATE SEQUENCE pans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pans_id_seq OWNER TO xiang;

--
-- Name: pans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xiang
--

ALTER SEQUENCE pans_id_seq OWNED BY pans.id;


--
-- Name: post_pans; Type: TABLE; Schema: public; Owner: xiang; Tablespace: 
--

CREATE TABLE post_pans (
    post_id integer NOT NULL,
    pan_id integer NOT NULL
);


ALTER TABLE public.post_pans OWNER TO xiang;

--
-- Name: posts; Type: TABLE; Schema: public; Owner: xiang; Tablespace: 
--

CREATE TABLE posts (
    id integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    link text NOT NULL,
    title text NOT NULL,
    abstract text NOT NULL,
    content text,
    pans integer DEFAULT 0,
    viewed integer DEFAULT 0,
    clicked integer DEFAULT 0,
    starts integer DEFAULT 0,
    site_id integer NOT NULL,
    update_date timestamp without time zone,
    tags text,
    CONSTRAINT posts_clicked_check CHECK ((clicked >= 0)),
    CONSTRAINT posts_pans_check CHECK ((pans >= 0)),
    CONSTRAINT posts_starts_check CHECK (((starts >= 0) AND (starts <= 5))),
    CONSTRAINT posts_viewed_check CHECK ((viewed >= 0))
);


ALTER TABLE public.posts OWNER TO xiang;

--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: xiang
--

CREATE SEQUENCE posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.posts_id_seq OWNER TO xiang;

--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xiang
--

ALTER SEQUENCE posts_id_seq OWNED BY posts.id;


--
-- Name: sites; Type: TABLE; Schema: public; Owner: xiang; Tablespace: 
--

CREATE TABLE sites (
    id integer NOT NULL,
    host text NOT NULL,
    posts integer DEFAULT 0,
    CONSTRAINT sites_posts_check CHECK ((posts >= 0))
);


ALTER TABLE public.sites OWNER TO xiang;

--
-- Name: sites_id_seq; Type: SEQUENCE; Schema: public; Owner: xiang
--

CREATE SEQUENCE sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sites_id_seq OWNER TO xiang;

--
-- Name: sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xiang
--

ALTER SEQUENCE sites_id_seq OWNED BY sites.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: xiang
--

ALTER TABLE ONLY pans ALTER COLUMN id SET DEFAULT nextval('pans_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: xiang
--

ALTER TABLE ONLY posts ALTER COLUMN id SET DEFAULT nextval('posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: xiang
--

ALTER TABLE ONLY sites ALTER COLUMN id SET DEFAULT nextval('sites_id_seq'::regclass);


--
-- Data for Name: pans; Type: TABLE DATA; Schema: public; Owner: xiang
--

COPY pans (id, link, clicked) FROM stdin;
2810	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1dDgmKP7	0
2811	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1qWjoglm	0
2812	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1jGqlj1O	0
2813	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1ntLS0bR	0
2814	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D3700477495%26uk%3D1275587257%23dir%2Fpath%3D%252F%25E8%258B%25B1%25E5%2589%25A7%252F%25E7%25BB%25BF%25E7%25BF%25BC%25EF%25BC%2588%25E6%2580%25AA%25E5%258C%25BB%25E4%25B8%2580%25E7%25AE%25A9%25E7%25AD%2590%25EF%25BC%2589Green%2520Wing	0
2815	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1pJ0lFM7	0
2816	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1o6oc3fc	0
2817	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1gdeLYV5	0
2818	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1sjvw9OT	0
2819	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1o6x46F4	0
2820	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1pJqGT3H	0
2821	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fplay%2Fvideo%23video%2Fpath%3D%252F%25E6%259D%258E%25E5%25B0%258F%25E7%2592%2590%25E4%25B8%2580%25E5%2588%2586%25E9%259B%25B6%25E5%2585%25AB%25E7%25A7%2592%2540%25E4%25B8%2580%25E4%25BB%258B%25E6%2593%25BC%25E5%25A4%25AB.mp4%26t%3D-1	0
2822	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1kTE5NCj	0
2823	http://www.douban.com/link2?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Fhome%3Fuk%3D1913128246%23category%2Ftype%3D0&vendor=from_people_intro&type=redir&link2key=116f040059	0
2824	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1d7O8A	0
2825	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1D2pOU	0
2826	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1sj8oQID	0
2827	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1sj4Qavz	0
2828	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F11WLWi	0
2829	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1sj6QViH	0
2830	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1sjlShPV	0
2831	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1bnCdYu7%3Fqq-pf-to%3Dpcqq.group	0
2832	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Finit%3Fshareid%3D3309625131%26uk%3D1996720672	0
2833	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1c0AHvkW	0
2834	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D4224075212%26uk%3D654329891	0
2835	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D227982%26uk%3D3492765234	0
2836	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1pJFdjL5	0
2837	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1qWK0PAW	0
2838	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1jGwW4j8	0
2839	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1dDEIiL7	0
2840	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1c0Aa5kk	0
2841	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fdisk%2Fhome	0
2842	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1jGHVKua	0
2843	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1c0gUT2K	0
2844	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1qWk6CHm	0
2845	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1iBRB	0
2846	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Fhome%3Fuk%3D4047436501%23category%2Ftype%3D0	0
2847	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1jCqOi	0
2848	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1gT5G5	0
2849	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1o6nYpq6	0
2850	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1f9wPw	0
2851	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F149eDY	0
2852	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1jGBMyXo	0
2853	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1gdBSXVX	0
2854	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1eQd2npK	0
2855	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1o68ZXAq	0
2856	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1mg8yeEW	0
2857	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D564840405%26uk%3D538651885%26qq-pf-to%3Dpcqq.group	0
2858	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D528635%26uk%3D2553635153	0
2859	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D1216523300%26uk%3D2520198491	0
2860	http://pan.baidu.com/s/1h8fge	0
2861	http://pan.baidu.com/share/link?shareid=216648&uk=2517937336	0
2862	http://pan.baidu.com/share/link?shareid=1329329877&uk=2517937336	0
2863	http://pan.baidu.com/s/1hqHW6uo	0
2864	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1c0h9EIs	0
2865	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1c0f7Ozu	0
2866	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Fhome%3Fuk%3D3812662438%23category%2Ftype%3D0	0
2867	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1jGG9spS	0
2868	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1dDejUEl	0
2869	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1qW2jMJq	0
2870	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1qWAXI2o	0
2871	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1sjLLboL	0
2872	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1jGC6e1o	0
2873	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1dDrHvyD	0
2874	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1hqC9YXu	0
2875	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1Dycob	0
2876	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Finit%3Fshareid%3D3652491308%26uk%3D1311797814	0
2877	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D511591%26uk%3D1295503450	0
2878	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D197730263%26uk%3D1311797814	0
2879	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Finit%3Fshareid%3D1747606614%26uk%3D1311797814	0
2880	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D413020%26uk%3D808823869%23dir	0
2881	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1bUXU	0
2882	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D666269382%26uk%3D523449137	0
2883	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1i3BPik9	0
2884	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1i37ialJ	0
2885	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1qWGxkg0	0
2886	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1ntDLzsP	0
2887	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1kTHTpYZ	0
2888	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1o6z6q50	0
2889	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1o62UcOi	0
2890	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1i3gdDYH	0
2891	http://movie.douban.com/doulist/3568593/comments/#c-1011663	0
2892	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1i340L0p	0
2893	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1dDkqkLz	0
2894	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1gdj6k6J	0
2895	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1sjNNvHz	0
2896	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1jGwXoeq	0
2897	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1nt1APK1	0
2898	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1kTmfQZ1	0
2899	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1c0pbVI4	0
2900	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1dD8CGEH	0
2901	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1o6lZMhO	0
2902	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1qWygTvm	0
2903	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1sj8ot0h	0
2904	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Finit%3Fshareid%3D1417835202%26uk%3D1596919477	0
2905	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1i3yvmg1	0
2906	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1kTJVPcV	0
2907	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1i31dbdb	0
2908	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Finit%3Fshareid%3D1117737776%26uk%3D1596919477	0
2909	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1mgkbY4o	0
2910	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1c0jCpDu	0
2911	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1c07YL7y	0
2912	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1dD27h3j	0
2913	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1dDeQCmd	0
2914	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1bnvPTzp	0
2915	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D2334139568%26uk%3D1291957132	0
2916	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D373476%26uk%3D1898713376	0
2917	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D447585%26uk%3D4197772903%26third%3D2	0
2918	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1Bw6Rv	0
2919	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D361708%26uk%3D3439715702	0
2920	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D1316702088%26uk%3D3963549632%26fid%3D3718318204	0
2921	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1ntHP0gD	0
2922	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1i3BlOgP	0
2923	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1i3GBeF7	0
2924	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1o6JOGn4	0
2925	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1c0IhmSC	0
2926	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1qWJeItQ	0
2927	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1dDEHwuX	0
2928	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1hq2zYuw	0
2929	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1kTDPl11	0
2930	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1ntwQiwx	0
2931	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1kvvFw	0
2932	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1s2Oz0	0
2933	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1pJjUPPD	0
2934	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1gd9T739	0
2935	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1sjKyAoX	0
2936	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1c0GLrlm	0
2937	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1ntiCZBr	0
2938	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1i30wekX	0
2939	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1ntx6hmx	0
2940	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1mgqg9xY	0
2941	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1i3eH04d	0
2942	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1i3eHyi5	0
2943	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1gdFto3p	0
2944	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1pJNk2BT	0
2945	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1eQgj2Jw	0
2946	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1mg6v7Sk	0
2947	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1pJK2f83	0
2948	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1pJkAfOZ	0
2949	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1sj4joCH	0
2950	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1ntz70zZ	0
2951	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1sjyJITf	0
2952	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1bnreygn	0
2953	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1nthWWlj	0
2954	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1xScDw	0
2955	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1mgnyEM0	0
2956	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1dDd3xXR	0
2957	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1ntJQiTV	0
2958	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1c0273Mw	0
2959	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1eQyzMAQ	0
2960	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1kT0X071	0
2961	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1eQ3PN5S	0
2962	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1h7nle	0
2963	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1i3IC4mD	0
2964	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1c0temxa	0
2965	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1pJPlOUJ	0
2966	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1jGDQ4bc	0
2967	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1ntuhMul	0
2968	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1AIGou	0
2969	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1hqHYYsW	0
2970	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1c03nQBu	0
2971	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F11VIUE	0
2972	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1i33dnu9	0
2973	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1sjrrOlf	0
2974	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1jG9NxJ4	0
2975	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D472200%26uk%3D3543487379	0
2976	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1jG2ZCto	0
2977	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1pJi6CA3	0
2978	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1sj2fuUx	0
2979	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D472188%26uk%3D3543487379	0
2980	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D472202%26uk%3D3543487379	0
2981	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1mgCyWDa	0
2982	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1dD5REJv	0
2983	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D472205%26uk%3D3543487379	0
2984	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1kT0VDOF	0
2985	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D472279%26uk%3D3543487379	0
2986	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1qWFE6V6	0
2987	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1vOtL8	0
2988	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1jGyVQg2	0
2989	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1pJyfGsr	0
2990	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1hqDnd68	0
2991	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1jGskotS	0
2992	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1kZcPw	0
2993	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D472302%26uk%3D3543487379	0
2994	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D472224%26uk%3D3543487379	0
2995	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1dDoWCKD	0
2996	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D472228%26uk%3D3543487379	0
2997	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D472225%26uk%3D3543487379	0
2998	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1i3yrUZF	0
2999	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1sjPLVrR	0
3000	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1sjLIjcL	0
3001	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1hqp627i	0
3002	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1jGxCyyy	0
3003	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1pJI1nkf	0
3004	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1i3zaAax	0
3005	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1eQknBvs	0
3006	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1kT3GqmN	0
3007	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1qWnrcK0	0
3008	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1bnAck9p	0
3009	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1dD9Ye5N	0
3010	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1qWEvxYO	0
3011	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1pJwg4xd	0
3012	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1qWx0wJq	0
3013	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1kT1EunP	0
3014	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1qWtwHzA	0
3015	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1jGiJBcM	0
3016	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D2927494461%26uk%3D1510261744	0
3017	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D2527459536%26uk%3D3693385804	0
3018	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1hqsraXQ	0
3019	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1i35Mkuh	0
3020	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1o6lZnC2	0
3021	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1jGjz6Jk	0
3022	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D2172834579%26uk%3D1947172976%26fid%3D98308447	0
3023	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D3086626799%26uk%3D3808847845	0
3024	http://www.douban.com/link2/?url=http%3A%2F%2Fblog.jitatang.com%2Fguitarpro6.html&link2key=07226e1217	0
3025	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1bn7ux7T	0
3026	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1pJuKHXh	0
3027	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fwap%2Flink%3Fshareid%3D2314608106%26uk%3D4178298268%26third%3D0%26page%3D1	0
3028	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1qWpYz84	0
3029	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D3295180141%26uk%3D1513411302	0
3030	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1eQ7m8Ky	0
3031	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D200915%26uk%3D1628597749	0
3032	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Fhome%3Fuk%3D687951596	0
3033	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1i35K4zb	0
3034	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1jGJYNem	0
3035	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1kTLX1x9	0
3036	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1gj4dj	0
3037	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1o67DJAU	0
3038	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1qWArEsW	0
3039	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1hqDqebi	0
3040	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1ntv5KRR	0
3041	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1kTkK2Qb	0
3042	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1dD5VlbN	0
3043	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1i3l37Xb	0
3044	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1bnktFdl	0
3045	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flinkshareid1329329877u	0
3046	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D528282%26uk%3D2769149121	0
3047	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1mgkbw3e	0
3048	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1c0jC992	0
3049	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1sjpsgMh	0
3050	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1pJJiiCF	0
3051	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D4197817151%26uk%3D624665533	0
3052	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1pJ2SjN1	0
3053	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1o62o4MQ	0
3054	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1sjCYM9f	0
3055	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D412413%26uk%3D4248151572	0
3056	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D473852%26uk%3D3577060223	0
3057	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1i3uWCKl	0
3058	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D1931474365%26uk%3D504273305	0
3059	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1bnEfL1P	0
3060	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1xmMHC	0
3061	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1eQj8r9g	0
3062	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1jGqREK2	0
3063	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1bnxR70j	0
3064	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1eQBsCGa	0
3065	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1bnnbUgv	0
3066	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1eQsv2yI	0
3067	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1qWK0RXM	0
3068	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1pJz3PQb	0
3069	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1gduu2VT	0
3070	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1BzbWE	0
3071	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F10BlLG	0
3072	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1hqKHHRm	0
3073	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1kTmevaf	0
3074	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1o6Fces6	0
3075	http://www.douban.com/link2?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D2615699177%26amp%3Buk%3D623526018%23&vendor=from_people_intro&type=redir&link2key=07226e1217	0
3076	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Fhome%3Fuk%3D490155926%26view%3Dshare%23category%2Ftype%3D0	0
3077	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D3603790200%26uk%3D4263690679	0
3078	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D2819512188%26uk%3D4263690679	0
3079	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1sj56FHb	0
3080	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1gdKcogz	0
3081	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1xPEqy	0
3082	http://pan.baidu.com/s/1pJi9ogV	0
3083	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1kTA1VO7	0
3084	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1hqKHzEG	0
3085	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D1422353717%26uk%3D3426659273%26third%3D15	0
3086	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D1426037660%26uk%3D3426659273%26third%3D15	0
3087	http://www.douban.com/link2?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Fhome%3Fuk%3D2133036986&vendor=from_people_intro&type=redir&link2key=07226e1217	0
3088	http://www.douban.com/link2?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Fhome%3Fuk%3D2450455396&vendor=from_people_intro&type=redir&link2key=07226e1217	0
3089	http://www.douban.com/link2?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Fhome%3Fuk%3D573819632&vendor=from_people_intro&type=redir&link2key=07226e1217	0
3090	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1kT9MvbD	0
3091	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1mgqhT8G	0
3092	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1qWjTwsO	0
3093	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D4092918309%26uk%3D2953729354%26app%3Dzd	0
3094	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1pLqaE	0
3095	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1c0zk5Vi	0
3096	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1GQzDG	0
3097	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1jGt8SSI	0
3098	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1pJqbjRl	0
3099	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1o66Y75C	0
3100	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D453958897%26uk%3D1998870170	0
3101	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1gdCCix9	0
3102	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D1890060508%26uk%3D2853545879	0
3103	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1dD265dn	0
3104	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1kTwoAcZ	0
3105	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1bnjEpkj	0
3106	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1dDy39S1	0
3107	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1mgLqcn2	0
3108	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D203836%26uk%3D724874371%26third%3D15	0
3109	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D245384%26uk%3D724874371%26third%3D15	0
3110	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1sjNePVf	0
3111	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1bn4Dj3L	0
3112	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1mgkbBbq	0
3113	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1sjFEjz3	0
3114	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1i33e0vF	0
3115	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1pJ38jO3	0
3116	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1dDqvglj	0
3117	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1hq9miu4	0
3118	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1o6DJ4Em	0
3119	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F17oamv	0
3120	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1eQ02ZeU	0
3121	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1bncRXgz	0
3122	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1kTlzq9x	0
3123	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1bn3qA1x	0
3124	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1sjwI5rv	0
3125	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1bngpVA3	0
3126	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1dD8C4N3	0
3127	http://www.douban.com/link2?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D2314028718%26amp%3Buk%3D3909324753&vendor=from_people_intro&type=redir&link2key=07226e1217	0
3128	http://www.douban.com/link2?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D1552246441%26amp%3Buk%3D3909324753&vendor=from_people_intro&type=redir&link2key=07226e1217	0
3129	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1i39R1QH	0
3130	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D3967960730%26uk%3D1060196341	0
3131	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1hqmRusO	0
3132	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1mguQLU4	0
3133	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Fhome%3Fuk%3D2450455396	0
3134	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1i3khGot	0
3135	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Finit%3Fshareid%3D45751051%26uk%3D1043271799	0
3136	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1eQ46J54	0
3137	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1hqA5GtY	0
3138	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1kTr5Jmf	0
3139	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1bnu4qWR	0
3140	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D2917268207%26uk%3D218397692%26fid%3D1962290694	0
3141	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1eQxKJey	0
3142	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1qW8V5Ju	0
3143	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D504935842%26uk%3D2754505399	0
3144	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fwap%2Flink%3Fshareid%3D3190029636%26uk%3D1094384564%26uid%3D1399872303440_304%26ssid%3De3ea1ab6e21edcc3327ed70748e596ae.3.1399872314.1.05qTXpNNeU4y	0
3145	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1hqKbtx6	0
3146	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1kTG8jfL	0
3147	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1i3HrYqL	0
3148	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1nt8whjN	0
3149	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1jGsT8Ei	0
3150	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1ntFhJmD	0
3151	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1rhKFc	0
3152	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1grU6y	0
3153	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Fhome%3Fuk%3D288509569%26view%3Dshare%23category%2Ftype%3D0	0
3154	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D299756%26uk%3D3204509438	0
3155	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1eQ7UFIy	0
3156	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1c0y4Qic	0
3157	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1jG1G5Rw	0
3158	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D665585644%26uk%3D2718753079%23dir	0
3159	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D665585644%26uk%3D2718753079%26fid%3D3608137869	0
3160	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1mg7ctOO	0
3161	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1nt0VbIx	0
3162	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1mgDhX5A	0
3163	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1ntFivd3	0
3164	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1o639RKY	0
3165	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1qWHJSPA	0
3166	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D122906%26uk%3D4197022826	0
3167	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1ntFfsGL	0
3168	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1EgTlW	0
3169	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1dDGHfep	0
3170	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1mg5GsXi	0
3171	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1nt4qcHj	0
3172	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1kTkJDQ3	0
3173	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1BwamU	0
3174	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1ntBJVVN	0
3175	http://www.douban.com/link2?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Fhome%3Fuk%3D1866243616%23category%2Ftype%3D0&vendor=from_people_intro&type=redir&link2key=07226e1217	0
3176	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1ntAuoXF%23dir	0
3177	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1iufsM	0
3178	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1jGsonDO	0
3179	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1ntDfgNZ	0
3180	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1eQnBz3s	0
3181	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1dDDweFR	0
3182	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Flink%3Fshareid%3D1433770441%26uk%3D1142242685	0
3183	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1gd7maR5	0
3184	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1dDvcVLJ	0
3185	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1mg9ekNA	0
3186	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1c0Ggapa	0
3187	http://www.douban.com/link2/?url=http%3A%2F%2Fpan.baidu.com%2Fs%2F1qWK0Mg0	0
\.


--
-- Name: pans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xiang
--

SELECT pg_catalog.setval('pans_id_seq', 3187, true);


--
-- Data for Name: post_pans; Type: TABLE DATA; Schema: public; Owner: xiang
--

COPY post_pans (post_id, pan_id) FROM stdin;
2797	2810
2797	2811
2798	2812
2798	2813
2800	2814
2799	2812
2799	2813
2794	2815
2794	2816
2801	2817
2801	2818
2796	2819
2796	2820
2796	2821
2793	2822
2787	2823
2791	2824
2816	2825
2817	2826
2812	2827
2812	2828
2814	2829
2814	2830
2808	2831
2808	2832
2802	2833
2803	2817
2803	2818
2781	2834
2781	2835
2777	2836
2777	2837
2777	2838
2780	2839
2780	2840
2780	2841
2780	2842
2774	2843
2768	2844
2768	2845
2768	2846
2768	2847
2768	2848
2768	2849
2768	2850
2768	2851
2768	2852
2768	2853
2766	2854
2766	2855
2766	2856
2762	2857
2759	2858
2763	2859
2765	2860
2765	2861
2765	2862
2765	2863
2754	2864
2754	2865
2754	2866
2754	2867
2749	2868
2749	2869
2753	2870
2753	2871
2753	2872
2753	2873
2753	2874
2750	2875
2750	2876
2750	2877
2750	2878
2750	2879
2750	2880
2750	2881
2747	2882
2741	2883
2744	2884
2744	2885
2744	2886
2744	2887
2744	2888
2744	2889
2744	2890
2743	2891
2734	2892
2734	2893
2734	2894
2734	2895
2734	2896
2734	2897
2734	2898
2734	2899
2734	2900
2734	2901
2734	2902
2734	2903
2734	2904
2734	2905
2734	2906
2734	2907
2734	2908
2734	2909
2734	2910
2734	2911
2734	2912
2734	2913
2735	2914
2742	2915
2742	2916
2742	2917
2742	2918
2742	2919
2742	2920
2739	2921
2738	2922
2728	2923
2728	2924
2728	2925
2728	2926
2728	2927
2728	2928
2728	2929
2728	2930
2728	2931
2728	2932
2728	2933
2728	2934
2728	2935
2728	2936
2728	2937
2728	2938
2728	2939
2728	2940
2728	2941
2728	2942
2728	2943
2728	2944
2728	2945
2728	2946
2730	2947
2730	2948
2730	2949
2730	2950
2730	2951
2730	2952
2730	2953
2730	2954
2730	2955
2730	2956
2730	2957
2730	2958
2730	2959
2730	2960
2730	2961
2730	2962
2730	2963
2730	2964
2730	2965
2730	2966
2730	2967
2730	2968
2730	2969
2730	2970
2730	2971
2730	2972
2730	2973
2730	2974
2731	2975
2731	2976
2731	2977
2731	2978
2731	2979
2731	2980
2731	2981
2731	2982
2731	2983
2731	2984
2731	2985
2731	2986
2731	2987
2731	2988
2731	2989
2731	2990
2731	2991
2731	2992
2731	2993
2731	2994
2731	2995
2731	2996
2731	2997
2731	2998
2731	2999
2731	3000
2731	3001
2724	3002
2737	3003
2737	3004
2737	3005
2737	3006
2737	3007
2737	3008
2737	3009
2737	3010
2737	3011
2737	3012
2737	3013
2720	3014
2720	3015
2732	3016
2746	3017
2761	3018
2761	3019
2761	3020
2767	2854
2767	2855
2767	2856
2785	3021
2785	3022
2785	3023
2775	3024
2806	3025
2806	3026
2786	3027
2779	3028
2779	3029
2779	3030
2779	3031
2779	3032
2779	3033
2804	2914
2789	3034
2911	3035
2910	3036
2913	3037
2916	3038
2907	3039
2906	3040
2904	3041
2901	3042
2900	3043
2903	3044
2897	3045
2898	3046
2895	3047
2894	3048
2889	3049
2886	3050
2884	3051
2888	3052
2881	3053
2882	2843
2878	3054
2874	3027
2876	3055
2876	3056
2872	2843
2869	3057
2868	3058
2861	3059
2861	3060
2852	3061
2852	3062
2846	3063
2846	3064
2843	2817
2843	2818
2842	3065
2842	3066
2847	3067
2831	3068
2831	3069
2840	3070
2835	2817
2835	2818
2830	3071
2830	3072
2832	3073
2823	3074
2828	3075
2828	3076
2833	3077
2833	3078
2818	3079
2818	3080
2841	3081
2856	3082
2824	3083
2824	3084
2848	3085
2848	3086
2820	3087
2820	3088
2820	3089
2880	3090
2887	3091
2890	3092
2870	3093
2896	3094
2908	3095
2917	3096
2915	3097
2893	3098
2845	3083
2845	3084
3015	3099
3014	3100
3011	3101
3005	3102
3009	3103
3010	2967
3004	3104
3001	3105
3000	3106
2993	3107
2994	3108
2994	3109
2989	3102
2986	3110
2983	3111
2980	3044
2977	3112
2975	3113
2974	3114
2974	3115
2974	3116
2974	3117
2972	3118
2969	3119
2968	3039
2971	3120
2966	3121
2963	3122
2955	3123
2959	3124
2953	3125
2950	2973
2944	3126
2949	3127
2949	3128
2941	3129
2938	3092
2933	3130
2937	3124
2931	3131
2930	3132
2935	3133
2925	3134
2927	3135
2924	3136
2929	3137
2926	3138
2918	3044
2942	3139
2945	3140
2948	3141
2957	3142
2961	3143
2976	2973
2991	3144
2985	3145
2982	3146
2995	3147
3006	3148
3017	2967
2958	3149
2964	3095
2952	3150
3012	3151
2939	3152
3087	3153
3084	3095
3092	3154
3080	3155
3089	3156
3090	3157
3082	3047
3081	3158
3081	3159
3076	3160
3078	3161
3075	3162
3072	3163
3070	3057
3068	3014
3067	2967
3064	3141
3065	3047
3061	3164
3057	3165
3053	3166
3056	3167
3056	3168
3056	3169
3052	3124
3038	3170
3042	3171
3034	3172
3046	3039
3037	2967
3035	3124
3060	3173
3031	3174
3030	3175
3030	3176
3033	3177
3025	3146
3026	2967
3029	3178
3032	3112
3024	3179
3036	3180
3021	3181
3018	3037
3062	3182
3069	3183
3079	3184
3091	3185
3085	3092
3040	3186
3083	3187
3077	3014
\.


--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: xiang
--

COPY posts (id, created, link, title, abstract, content, pans, viewed, clicked, starts, site_id, update_date, tags) FROM stdin;
2855	2014-05-29 20:53:19.543813	http://9.douban.com/subject/9454651/	MacIdea - Mac 软件共享(九点) - 豆瓣	Movist 1.3.7 最新版！ 2014-05-07 17:40:15 查看原文. 直接上链接： [url=http://pan.baidu.com/s/1i3xEJul]http://pan.baidu.com/s/1i3xEJul[/url] 提取码：a59z. 推荐 ...	\N	0	0	0	0	3	2014-05-05 00:00:00	2014,05,14,原文,23,查看,软件,...,本帖,http,GTD,39,12,推荐,注销,url,mac,com,03,&#
2729	2014-05-29 20:52:37.070164	http://www.douban.com/group/topic/53324184/?type=rec	【哇靠】6月日杂免费，持续更新	你们有啥想看的日杂都可以报出来！ 只能服饰美容！！ 【2014年6月【cancam】 14年06月号314P 日文】 cancam》 14年06月链接：http://pan.baidu.com/s/1jGhycOQ ...	\N	0	0	0	0	3	2014-05-28 20:52:36.913486	\N
2998	2014-05-29 20:53:52.599626	http://www.douban.com/group/topic/52520208/	赠送化妆教程、速来打包。 - 豆瓣	来自: 秘鲁的麋鹿 2014-05-09 12:33:48. 所以资料已经分享到朋友圈。链接: http://pan.baidu.com/s/1pJuKKbx 化妆视频全教程. 1人 喜欢 喜欢 · 回应 推荐 喜欢 只看 ...	\N	0	0	0	0	3	2014-05-09 00:00:00	\N
2733	2014-05-29 20:52:37.103551	http://www.douban.com/link2?url=http%3A%2F%2Fpan.baidu.com%2Fshare%2Fhome%3Fuk%3D3443434646%23category%2Ftype%3D0&vendor=from_people_intro&type=redir&link2key=0761736b98	百度云网盘-丁不悔是小护士的分享	百度网盘为您提供文件的网络备份、同步和分享服务。空间大、速度快、安全稳固，支持教育网加速，支持手机端。现在注册即有机会享受15G的免费存储空间.	\N	0	0	0	0	3	2014-05-01 00:00:00	\N
2736	2014-05-29 20:52:37.12854	http://www.douban.com/group/topic/52238920/	相信就来，不相信就绕着走。。。。 - 豆瓣	儿童营养餐下载链接: http://pan.baidu.com/s/1c0temxa 密码: dbcb 2、高清：郑多燕减肥资料下载链接: http://pan.baidu.com/s/1eQyzMAQ 密码: ogmx 3、减肥秘籍 ...	\N	0	0	0	0	3	2014-05-03 00:00:00	\N
2727	2014-05-29 20:52:37.05352	http://movie.douban.com/doulist/2463200/	德语电影下载备忘录C - 豆瓣电影	主演: Evelyn Hamann/Vicco von Bülow/伊尔姆·海尔曼Irm Hermann. 评语 : http://pan.baidu.com/s/1bneTlEZ 英语字幕，德国幽默一瞥，基本上也算是德语学生必看的 ...	\N	0	0	0	0	3	2014-05-23 20:52:36.91252	com,http,评语,导演,主演,middot,拜读,baidu,盘点,字幕,pan,TLF,出品,英语,von,amp,05,电影,小易甫
2738	2014-05-29 20:52:37.145204	http://www.douban.com/group/topic/52376106/	老友记彩蛋一个，菲比的弟弟 - 豆瓣	链接：http://pan.baidu.com/s/1i3BlOgP 密码：5tlt 看看能不能用，可能很快失效 链接：http://pan.baidu.com/s/1i3BlOgP 密码：5tlt 看看能不能用，可能很快失效 盒汁人.	\N	1	0	0	0	3	2014-05-06 00:00:00	2014,06,05,com,楼主,14,链接,盒汁,删除,困兽,pan,http,baidu,5tlt,1i3BlOgP,菲比,douban,失效,字幕
2726	2014-05-29 20:52:37.045174	http://music.douban.com/doulist/569049/?start=25&filter=	iTunes music AAC <DL> - 豆瓣音乐	表演者: Crystal Fighters 出版者: Zirkulo. 评语 : http://pan.baidu.com/share/link?shareid=676905&uk=1812172327 (rxdl) [Mastered for iTunes] ...	\N	0	0	0	0	3	2014-05-11 00:00:00	com,http,表演者,出版者,pan,baidu,评语,收听,uk,shareid,share,link,amp,1812172327,Records,iTunes,middot,Mastered,2013
2723	2014-05-29 20:52:37.020198	http://movie.douban.com/doulist/4058528/	铃木则文资源 - 豆瓣电影	2. 滴血双狼刀忍者武芸帳百地三太夫. 导演: 鈴木則文 主演: 真田広之/千葉真一/蜷川有紀. 评语 : http://pan.baidu.com/s/1jGzFe8u ...	\N	0	0	0	0	3	2014-05-17 00:00:00	com,pan,http,baidu,评语,主演,middot,铃木,导演,电影,鈴木則,池玲子,杉本,Suzuki,Norifumi,2014,美樹,美树,女番
2725	2014-05-29 20:52:37.036851	http://movie.douban.com/doulist/3905765/	敕使河原宏资源汇总 - 豆瓣电影	导演: 羽仁進/川頭義郎/草壁久四郎/丸尾定/松山善三/武者小路侃三郎/荻昌弘/向坂隆一郎/敕使河原宏 主演: Donald Richie. 评语 : （1958） http://pan.baidu.com/s/ ...	\N	0	0	0	0	3	2014-05-03 00:00:00	原宏,使河,com,pan,http,baidu,评语,主演,导演,middot,2014,汇总,电影,河原,Torres,Teshigahara,Hiroshi,1958,资源
2721	2014-05-29 20:52:37.003485	http://movie.douban.com/doulist/3968756/	【日本映画資料館】新藤兼人 - 豆瓣电影	1. 赤贫的19岁裸の十九才. 导演: 新藤兼人Kaneto Shindô 主演: 原田大二郎/乙羽信子. 评语 : 链接: http://pan.baidu.com/s/1pJjVjiN 密码: x3l9 ...	\N	0	0	0	0	3	2014-05-03 00:00:00	新藤兼人,http,com,pan,baidu,评语,主演,信子,乙羽,导演,middot,Shind,Kaneto,链接,密码,殿山泰司,竹雪,05,电影
2724	2014-05-29 20:52:37.028511	http://www.douban.com/group/topic/52146523/	格言别录开示汇集良因法师http://pan.baidu.c... - 豆瓣	标题：格言别录开示汇集良因法师http://pan.baidu.com/s/1jGxCyyy. 格言别录开示汇集 良因法师 http://pan.baidu.com/s/1jGxCyyy · 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	1	0	0	0	3	2014-04-30 00:00:00	小组,开示,良因,pan,http,baidu,别录,格言,com,2014,...,法师,登录,汇集,times,1jGxCyyy,注册,推荐
2719	2014-05-29 20:52:36.98689	http://movie.douban.com/doulist/3156401/	我上传的电影（日本）2 - 豆瓣电影	2. 在被逮捕前I am ICHIHASHI 逮捕されるまで. 导演: 藤冈靛Dean Fujioka 主演: 藤冈靛Dean Fujioka. 评语 : http://pan.baidu.com/s/1eQ7nIGa ...	\N	0	0	0	0	3	2014-05-14 00:00:00	http,com,pan,baidu,评语,主演,导演,middot,电影,05,Hamada,Hiroki,27,18,14,11,太郎,田中,上传
2718	2014-05-29 20:52:36.957356	http://movie.douban.com/doulist/4091361/	电影手册100部最美电影 - 豆瓣电影	1. 泯灭天使El ángel exterminador. 导演: Luis Buñuel 主演: Silvia Pinal/Enrique Rambal/Claudio Brook. 评语 : http://pan.baidu.com/s/1sjlodmH，提m0vn ...	\N	0	0	0	0	3	2014-05-23 20:52:36.907981	com,pan,http,baidu,评语,主演,导演,middot,电影,Jacques,Robert,Richard,Nikolai,Jean,James,George,Charles,Chaplin,America
2722	2014-05-29 20:52:37.012	http://www.douban.com/group/topic/52711758/	Records I Like (2014.05) - 豆瓣	Eternal Summers – The Drop Beneath (2014) http://music.douban.com/subject/25813502/ pan.baidu.com/s/1bnrJ9QB. The Horrors – Luminous (2014)	\N	0	0	0	0	3	2014-05-13 00:00:00	com,2014,http,douban,subject,pan,music,baidu,fabiano,小组,&#,05,登录,times,Records,Like,34,24
2732	2014-05-29 20:52:37.095163	http://www.douban.com/group/topic/52827429/	这个姿势了不起喜欢的留下邮箱哈 - 豆瓣	这个姿势了不起电子书下载地址http://pan.baidu.com/share/link?shareid=2927494461&uk=1510261 这个姿势了不起电子书下载 ...	\N	1	0	0	0	3	2014-05-16 00:00:00	http,com,amp,item,2014,les,05,16,11,地址,uk,shareid,share,pan,link,baidu,2927494461,了不起
2720	2014-05-29 20:52:36.995151	http://www.douban.com/group/topic/52403617/	我就是来要视频的！！ - 豆瓣	Alice (人懒嘴馋) 2014-05-07 00:01:17. http://pan.baidu.com/s/1jGiJBcM 刚刚有一个红领巾给的. 删除. 赞 回应 · 花花大人、 2014-05-07 00:01:19. M. 删除. 赞 回应 ...	\N	2	0	0	0	3	2014-05-06 00:00:00	05,2014,06,23,删除,楼主,00,07,com,http,pan,baidu,1jGiJBcM,手机,已阅,42,视频,36
2740	2014-05-29 20:52:37.161874	http://www.douban.com/group/topic/53067123/	念佛的拉拉们·闻法清心 - 豆瓣	我在这里 你在哪？ 清心小书下载地址： 第8期：http://pan.baidu.com/s/1pJlq8In 第7期：http://pan.baidu.com/s/1ntv1061 第6期：http://pan.baidu.com/s/19m8KG	\N	0	0	0	0	3	2014-05-21 00:00:00	\N
2871	2014-05-29 20:53:19.702452	http://www.douban.com/group/topic/52378771/	10万本畅销书来袭，豆豆们准备好内存送人了 - 豆瓣	书在百度网盘里，想要的豆子请点击链接:在下面！ 我的微信：haimei020 地址：密码在我朋友全动态哦！ //pan .baidu .com/s / 1o6 rxDv8 密码加我，找我那就行！	\N	0	0	0	0	3	2014-05-06 00:00:00	小组,爱书,2014,14,登录,朋友,喜欢,万本,穷游,微信,times,com,3000,29,10,06,05
2874	2014-05-29 20:53:19.727479	http://www.douban.com/group/topic/52286275/	熬夜六小时看完《战长沙》这部剧到现在为止剧中... - 豆瓣	顾氏夫妇. 中国好姐夫. 非常感谢楼里栢辰(元远) 同学给的down链接http://pan.baidu.com/wap/link?shareid=2314608106&uk=4178298268&third=0&amp;page=1.	\N	1	0	0	0	3	2014-05-04 00:00:00	05,2014,删除,剩儿,省心,16,04,省钱,10,快播,姐夫,吃饭,11,...,片花,杨紫,一个,啊啊啊
2876	2014-05-29 20:53:19.744199	http://www.douban.com/group/topic/53365730/	燥热的午后我们来一发吧	嗯不管你正在暴躁，还是正在暴操 我们先来分享一曲吧，就两分钟，其他什么都是虚的。 http://pan.baidu.com/share/link?shareid=412413&uk=4248151572	\N	2	0	0	0	3	2014-05-29 15:53:19.207362	小组,com,2014,登录,uk,times,shareid,share,pan,link,http,baidu,amp,29,28,15,05,注册
2752	2014-05-29 20:52:37.261905	http://www.douban.com/group/topic/52148043/	从零学瑜伽，各类经典教程，喜欢瑜伽的，去下载吧！ - 豆瓣	我的网盘：http://pan.baidu.com/s/1kTmevaf 加我V信时发送验证“瑜伽” 索取密码提取 给大家带来的不便请谅解！ 前段时间发了这么多邮箱，快累死了，所以请大家 ...	\N	0	0	0	0	3	2014-04-30 00:00:00	\N
2755	2014-05-29 20:52:37.286965	http://site.douban.com/196116/	英语有声读物和广播剧的小站 - 豆瓣	2014-05-24更新：经济学人杂志及音频. 音频| 151MB | 官网下崽─────→epub | mobi | pdf |百度下崽←─────链接：http://pan.baidu.com/s/1sjnoBO5 ...	\N	0	0	0	0	3	2014-05-24 20:52:36.926057	2014,05,...,11,24,04,分享,小站,有声书,我来,奶爸,gt,22,21,12,03,01,枪气
2758	2014-05-29 20:52:37.311897	http://movie.douban.com/doulist/3332203/	盤-一般 - 豆瓣电影	导演: Joseph Losey 主演: Richard Burton/Alain Delon/Romy Schneider/Valentina Cortese/Enrico Maria Salerno. 评语 : 【http://pan.baidu.com/s/1qrYuT】 ...	\N	0	0	0	0	3	2014-05-13 00:00:00	http,com,评语,主演,导演,中字,115,lb,简中,magnet,xt,urn,btih,阳光,心中,file,La,xml,www,quot
2748	2014-05-29 20:52:37.228572	http://site.douban.com/214861/room/2903712/	小站自汉化(永井三郎的小站) - 豆瓣	源嵌：☆ 修图：炖酸菜翻译：锅包肉校对：小e 声明小站汉化，仅供交流，禁止商业。 汉化发布3天后接受转载申请。 DL 链接: http://pan.baidu.com/s/1kT1E5E3 密码: ...	\N	0	0	0	0	3	2014-05-10 00:00:00	汉化,小站,http,com,永井三郎,2014,喜欢,staff,pan,baidu,分享,翻译,仅供,图源,03,转载,天后,交流,链接
2751	2014-05-29 20:52:37.253584	http://music.douban.com/doulist/1706732/	Metal Ⅱ - 豆瓣音乐	表演者: 惊叫基督/Screaming Savior 出版者: 号角唱片. 评语 : 20120120 ／ WS pan.baidu.com/s/1i33brE1 or rusfolder.com/37197527or depositfiles.com/files/ ...	\N	0	0	0	0	3	2014-04-30 00:00:00	com,files,表演者,出版者,depositfiles,评语,html,rar,Metal,unibytes,pan,baidu,middot,amp,Self,rusfolder,released,gigabase
2757	2014-05-29 20:52:37.30363	http://www.douban.com/people/tsubasafai/	透明人間 - 豆瓣	TK from 凛として时雨- flower&haze (ROCK IN JAPAN FES.2013 DAY-3 2013.09.06).ts pan.baidu.com/s/1xcBne 提取码jmyx 转自O ...	\N	0	0	0	0	3	2014-05-02 00:00:00	middot,時雨,gt,2014,05,http,com,2013,06,大橋,正太,大叔,关注,重症,人渣,豆列,强迫症
2745	2014-05-29 20:52:37.203576	http://site.douban.com/119902/room/784510/	室内设计(我爱建筑的小站) - 豆瓣	... 新闻集团设计，位于土耳其伊斯坦布尔市。透明隔断，开放式的布局，凸显想象力与创造力。 下载：http://dl.vmall.com/c06sscrr2n 或http://pan.baidu.com/s/1kTqQziR.	\N	0	0	0	0	3	2014-05-27 20:52:36.921167	com,http,2014,05,vmall,dl,pan,baidu,建筑,室内设计,分享,设计,关注,小站,下载,喜欢,位于,javascript,PDF
2747	2014-05-29 20:52:37.220257	http://www.douban.com/group/topic/52303999/	会计人求一份2014年注会课本电子版 - 豆瓣	看来蛮多人想要啊，那我把地址贴出来好了，这是经济法的，http://pan.baidu.com/share/link?shareid=666269382&uk=523449137。 注会全套电子书我都有，有人要 ...	\N	1	0	0	0	3	2014-05-04 00:00:00	05,2014,二表哥,com,经济法,删除,qq,邮箱,09,谢谢,发给你,有个,同求,22,留个,网址,地址,蛮多人,share
2746	2014-05-29 20:52:37.211902	http://www.douban.com/group/topic/52951996/	有没有读过巫宁坤的《一滴泪》的，有电子版的可否... - 豆瓣	张宇新xyz 2014-05-19 16:44:58. http://pan.baidu.com/share/link?shareid=2527459536&uk=3693385804 简体版，是网友从外网下载 ...	\N	1	0	0	0	3	2014-05-19 00:00:00	2014,小组,com,19,05,...,简体版,电子版,张宇,巫宁坤,外网,xyz,uk,shareid,share,pan,link,http
2741	2014-05-29 20:52:37.17022	http://movie.douban.com/subject/6887029/discussion/55891303/	醉乡民谣Inside Llewyn Davis电影原声带iTunes正版AAC	标题："醉乡民谣Inside Llewyn Davis电影原声带iTunes正版AAC. Inside Llewyn Davis (Original Soundtrack） 链接: http://pan.baidu.com/s/1i3BPik9. 你认为这篇 ...	\N	1	0	0	0	3	2014-05-15 00:00:00	gt,2014,删除,2013,11,com,Llewyn,Inside,Davis,22,19,18,09,04,01,电影,醉乡,民谣,原声带
2743	2014-05-29 20:52:37.186858	http://movie.douban.com/doulist/3568593/	诺阿的英剧资源档 - 豆瓣电影	3. Harry Enfield's Television Programme. 评语 : http://pan.baidu.com/s/1mgoKK7Q。Harry Enfield的sketch show，参与的还有Paul Whitehouse和Kathy Burke。	\N	1	0	0	0	3	2014-05-06 00:00:00	评语,主演,com,http,None,pan,middot,baidu,Season,French,喜剧,导演,Dawn,Comedy,39,&#,纪录片,Nesbitt,Kevin
2739	2014-05-29 20:52:37.153555	http://www.douban.com/group/topic/52495522/	疑似李小璐的那个视频你们都看了吗？我觉得就是她！ - 豆瓣	rt，大家怎么说。。妈蛋。。都没看过吗。。我贴上来不会被干嘛把。。。好怕。。http://pan.baidu.com/s/1ntHP0gD大家看了再来说，我在百度知道找到的. 1人 喜欢 喜欢.	\N	1	0	0	0	3	2014-05-08 00:00:00	19,2014,08,05,删除,http,com,pan,baidu,1ntHP0gD,10,diors,小组,李小璐,14,12,不会
2756	2014-05-29 20:52:37.295284	http://www.douban.com/thing/101/?on=1054367	育儿 - 豆瓣	1 喜欢. 取名软件哪个好？ [攻略]. 宝宝取名软件注册版免费下载宝宝取名大师软件V23.0免费版下载http://pan.baidu.com/s/1h8fge 最新周易起名大师15.0免费版 ...	\N	0	0	0	0	3	2014-05-28 20:52:36.926541	......,喜欢,孩子,攻略,育儿,宝宝,com,http,妈妈,免费版,pan,baidu,取名,幼儿园,楼主,软件,下载
2853	2014-05-29 20:53:19.527146	http://site.douban.com/203136/widget/notes/12734949/note/353613263/	[口语这样说] 今日学习：适应环境 - 豆瓣	[口语这样说] 今日学习：适应环境. 2014-05-26 12:34:17. 附MP3，以供参考：http://pan.baidu.com/s/1qW0P0g0. 今日学习：适应环境. There's a new employee(职工) ...	\N	0	0	0	0	3	2014-05-26 20:53:19.195933	quot,settled,口语,new,英语,gt,适应环境,泰格,work,things,organize,javascript
2764	2014-05-29 20:52:37.362002	http://www.douban.com/group/topic/52398405/	【免费送，已更新】吐血分享最新化妆教程 - 豆瓣	美甲个人形象设计http://pan.baidu.com?/s/1pJFdjL5 提取码请加威信yany15800 获取 加我时发送验证“化妆” 索取密码提取 给大家带来的不便请谅解！ 有人说我是做 ...	\N	0	0	0	0	3	2014-05-06 00:00:00	\N
2861	2014-05-29 20:53:19.594087	http://www.douban.com/group/topic/52191075/	法郎士小说 - 豆瓣	我来发一个百度盘的链接，大家自己动手丰衣足食。 《天使的叛变》 http://pan.baidu.com/s/1xmMHC 《法郎士小说选》 http://pan.baidu.com/s/1bnEfL1P 祝阅读愉快！	\N	2	0	0	0	3	2014-05-01 00:00:00	法郎,小组,com,登录,小说,times,pan,http,baidu,Zelda,2014,注册,话题,哇噻,手机,行摄,我来,士写
2852	2014-05-29 20:53:19.518806	http://www.douban.com/group/topic/52992031/	秦晖：晚晴“西化”潮 - 豆瓣	来自: 哲别之箭 2014-05-20 10:43:10. 讲座环节http://pan.baidu.com/s/1eQj8r9g 交流环节http://pan.baidu.com/s/1jGqREK2 · 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	2	0	0	0	3	2014-05-20 00:00:00	小组,秦晖,com,讲座,登录,晚晴,西化,怪奇,哲别,之箭,times,pan,http,baidu,2014,10,注册,居士
2769	2014-05-29 20:52:37.403688	http://movie.douban.com/doulist/3332221/?collect=yes&ck=None	盤-稍好1 - 豆瓣电影	... Tóth/Judit Pogány. 评语 : 【http://pan.baidu.com/s/1jGkdpzg】或【http://115.com/lb/5lba19lzp656】內嵌英字,轉自：http://www.douban.com/group/topic/49338044/ ...	\N	0	0	0	0	3	2014-05-01 00:00:00	\N
2773	2014-05-29 20:52:37.437073	http://www.douban.com/group/topic/52483427/	【免费送教程】分享最新小白化妆视频 - 豆瓣	美甲个人形象设计http://pan.baidu.com?/s/1pJFdjL5 提取码请加威信yany15800 获取 加我时发送验证“化妆” 索取密码提取 给大家带来的不便请谅解！ 有人说我是做 ...	\N	0	0	0	0	3	2014-05-08 00:00:00	\N
2846	2014-05-29 20:53:19.46876	http://www.douban.com/group/topic/52933074/	关于上原香老师提到的，顾均正作品的原文 - 豆瓣	... 内）的数字化有些爱好者在做，目前有若干扫描了。上原老师提到的顾均正作品的部分原文来源的pulp杂志，我传了几本在度盘，http://pan.baidu.com/s/1eQBsCGa。	\N	2	0	0	0	3	2014-05-18 00:00:00	安子介,科幻小说,com,SF,艾维章,http,2014,塞尔维,小组,顾均,19,05,陆沉,科幻,译著,妈个,原香,html
2770	2014-05-29 20:52:37.412009	http://movie.douban.com/subject/4101481/	与君同行路(豆瓣) - 豆瓣电影	0 有用 eien99 2014-02-21. http://pan.baidu.com/s/1hBGke. 0 有用 欢乐分裂 2014-05-05. “蓬山此去无多路，青鸟殷勤为探看。”苦情+悲情。 0 有用 eien99 2014-02- ...	\N	0	0	0	0	3	2014-05-05 00:00:00	成濑巳喜,电影,2014,同行,05,运动,摄影机,eien99,com,21,12,短评,影评,看过,画外,蓬山,青鸟殷勤
2772	2014-05-29 20:52:37.428682	http://site.douban.com/119902/widget/notes/5123434/	建筑设计项目日志(豆瓣)	... 设有一个面积约1500平方米，最高高度约30米的酒店大堂，南向有三千余平米花园美景，成为酒店公共空间的核心。 下载PDF：http://pan.baidu.com/s/1jG1G5Rw.	\N	0	0	0	0	3	2014-05-09 00:00:00	com,http,2014,vmall,pan,dl,baidu,05,09,分享,设计,下载,展开,喜欢,推荐,位于,建筑设计,Architects,29
2774	2014-05-29 20:52:37.445385	http://www.douban.com/group/topic/53155165/	秦晖历史与现实中的土地问题 - 豆瓣	baidu真厉害，简直是秒删啊，我把文件名改成qh看好点不 秦晖历史与现实中的土地问题http://pan.baidu.com/s/1c0gUT2K · 1人 喜欢 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	1	0	0	0	3	2014-05-23 20:52:36.935157	秦晖,2014,小组,baidu,24,05,现实,哲别,之箭,com,00,登录,历史,土地,讲座,怪奇,times,qh
2776	2014-05-29 20:52:37.48708	http://www.douban.com/note/tags/%E5%85%AC%E5%8F%B8%E8%B5%B7%E5%90%8D%E6%B5%8B%E8%AF%95?people=55418400	lxigu的日记标签: 公司起名测试 - 豆瓣	【马宝宝取名】马年宝宝起名大全_2014马宝宝起名大全宝宝取名软件注册版免费下载宝宝取名大师软件V23.0免费版下载http://pan.baidu.com/s/1h8fge 最新周易起名 ...	\N	0	0	0	0	3	2014-05-26 20:52:36.936125	起名,大全,取名,公司,2014,宝宝,软件,名字,取名字,http,com,下载,马年,破解版,pan,middot,免费,免费版,baidu,测试
2771	2014-05-29 20:52:37.42064	http://movie.douban.com/subject/3114674/	畸型人魔(豆瓣) - 豆瓣电影	3 有用 sakana 2012-08-15. 粤语配音，饭田让治的处女实验短片http://pan.baidu.com/share/link?shareid=1378700670&uk=2399432701 ...	\N	0	0	0	0	3	2014-05-09 00:00:00	电影,畸型,15,短评,评论,折叠,短片,2013,04,粤语,配音,这部,马提,饭田,com,amp,2014,10
2763	2014-05-29 20:52:37.353682	http://www.douban.com/group/topic/52473385/	作为一个刚看完第一遍老友记的孩子 - 豆瓣	我那有高清720的你可以去下载 我那有高清720的你可以去下载 Patrick · http://pan.baidu.com/share/link?shareid=1216523300&uk=2520198491. 删除. 赞 回应 ...	\N	1	0	0	0	3	2014-05-08 00:00:00	2014,05,08,删除,11,Joey,Chandler,...,隔座,春酒,Ross,Rachel,老友记,高清,22,com,16,09,uk
2762	2014-05-29 20:52:37.345286	http://www.douban.com/group/topic/52438096/	确定那个是李小璐不是王思佳？ - 豆瓣	YinYin 2014-05-07 20:34:38. http://pan.baidu.com/share/link?shareid=564840405&uk=538651885&qq-pf-to=pcqq.group 看完之后请速删！ 删除. 赞 回应 ...	\N	1	0	0	0	3	2014-05-07 00:00:00	05,2014,07,删除,李小璐,amp,16,同事,妹纸,com,Sunflower,21s,18,08,57,...,未婚,uk
2775	2014-05-29 20:52:37.478733	http://www.douban.com/group/topic/52486615/	【Guitar Pro 6.0.7 中文破解版】下载地址+安装教程 - 豆瓣	... 地址+安装教程. blog.jitatang.com. 下载地址：主程序下载地址：http://pan.baidu.com/s/1dDtHyqH音色包下载地址：http://pan.baidu.com/s/1pJjnDMz简体中文包 ...	\N	1	0	0	0	3	2014-05-08 00:00:00	com,地址,小组,pan,http,baidu,Pro,下载,登录,吉他,破解版,times,Guitar,6.0,2014,...,注册,连载
2767	2014-05-29 20:52:37.387018	http://www.douban.com/group/topic/53323629/	中级----2014年中级的课件资料免费下载-百度网盘	3、不限制电脑使用，建议用暴风、百度影音等播放； 4、不只是课件还有其他会计资料，如各种真账资料 2014年中级经济法http://pan.baidu.com/s/1eQd2npK 密码:je8s	\N	3	0	0	0	3	2014-05-28 20:52:36.931809	2014,中级,com,小组,课件,注会,百度网,pan,http,baidu,资料,登录,回帖,免费,下载,网盘,会计网,times,密码
2784	2014-05-29 20:52:37.55376	http://www.douban.com/group/topic/52388440/	【免费送，已更新】吐血分享最新化妆教程 - 豆瓣	2.全部化妆教程http://pan.baidu.com/s/1jGwW4j8 3.美甲个人形象设计http://pan.baidu.com/s/1pJFdjL5 提取码请加威信yany15800 获取 加我时发送验证“化妆” 索取 ...	\N	0	0	0	0	3	2014-05-06 00:00:00	\N
2843	2014-05-29 20:53:19.44376	http://www.douban.com/group/topic/52735853/	英语短篇小说精品和英文小说原著 - 豆瓣	链接: http://pan.baidu.com/s/1sjvw9OT 英语短篇小说精品 链接: http://pan.baidu.com/s/1gdeLYV5 英文小说原著 需要的朋友可以去我的朋友圈742715260. 1人 喜欢 ...	\N	2	0	0	0	3	2014-05-14 00:00:00	小组,原著,com,短篇小说,精品,登录,英文,英语,小说,times,pan,http,baidu,2014,...,淘沙,注册,链接
2788	2014-05-29 20:52:37.586919	http://www.douban.com/link2?url=http://blog.sina.com.cn/xiaowenzi22	小蚊子乐园_新浪博客	源文件下载：http://pan.baidu.com/s/1ntI6jRN. 相关阅读：. 阅读 ┆ 评论 ┆ 转载 ┆ 收藏. 查看全文>>. 【EXCEL查找函数系列】MATCH动态图解. (2014-05-22 21:35).	\N	0	0	0	0	3	2014-05-08 00:00:00	\N
2842	2014-05-29 20:53:19.43542	http://www.douban.com/group/topic/52705333/	沪江BEC全套课程分享	http://pan.baidu.com/s/1bnnbUgv 沪江课件专用播放器 发这个帖子感觉对沪江有点愧疚啊o(╯□╰)o 主要是沪江的课有时间限制而且因为卤煮自制力不够好几次报 ...	\N	2	0	0	0	3	2014-05-13 00:00:00	2014,05,楼主,删除,15,课程,沪江,商务英语,13,分享,谢谢,com,BEC,17,22,16,叶子,好人
2795	2014-05-29 20:52:37.645493	http://www.douban.com/group/topic/32240928/?cid=375931233	拗三观！无限吐槽马丽苏汤姆苏界的各种神文！ - 豆瓣	http://pan.baidu.com/share/link?shareid=414840&uk=34968829 看看这个地址能不能进去 http://pan.baidu.com/share/link?shareid=414840&uk=34968829 看看 ...	\N	0	0	0	0	3	2014-05-09 00:00:00	2014,05,删除,公主,纱玛特,云海,...,依依,啊啊啊,28,哈哈哈,再见,慕容,小岛,25,大白,美丽,流星
2800	2014-05-29 20:52:37.686973	http://www.douban.com/group/topic/27713494/?cid=364100668	【退散吧LZ忘记续期了】绿翼Green Wing 全二季+Sp... - 豆瓣	http://pan.baidu.com/share/link?shareid=3700477495&uk=1275587257#dir/path=%2F%E8%8B%B1%E5%89%A7%2F%E7%BB%BF%E7%BF%BC%EF%BC ...	\N	1	0	0	0	3	2014-05-07 00:00:00	删除,2012,11,楼主,08,http,com,E7,29,2014,2013,13,01,12,09,00,...,谢谢,LZ
2783	2014-05-29 20:52:37.54544	http://movie.douban.com/doulist/1757751/	恐怖片吧梦魇字幕组出品 - 豆瓣电影	导演: Santiago Segura 主演: Santiago Segura/Isabel Guasp/Carmen Arbex/Bea Revilla. 评语 : pan.baidu.com/share/link?shareid=115862&uk=2248406299 ...	\N	0	0	0	0	3	2014-05-20 00:00:00	com,yyets,http,www,resource,评语,主演,导演,middot,php,amp,John,Peter,Michael,39,21,&#,电影,字幕组
2801	2014-05-29 20:52:37.695492	http://www.douban.com/group/topic/52515653/	英语原版小说和英语短篇精品小说，速取··· - 豆瓣	链接: http://pan.baidu.com/s/1sjvw9OT 英语短篇小说精品 链接: http://pan.baidu.com/s/1gdeLYV5 英文小说原著 需要的朋友可以加我微信zyy0200. 2人 喜欢 喜欢.	\N	2	0	0	0	3	2014-05-09 00:00:00	05,2014,删除,13,15,16,14,18,22,20,19,23,17,12,11,10,24,21,28
2793	2014-05-29 20:52:37.628775	http://www.douban.com/group/topic/52575435/	大川端侦探社有人看么 - 豆瓣	KTEE.CN (KTEE.CN) 2014-05-10 20:37:58. 喜欢ed就是找不到mp3T^T 喜欢ed就是找不到mp3T^T Cat · http://pan.baidu.com/s/1kTE5NCj OP 和ED我都上传了.	\N	1	0	0	0	3	2014-05-10 00:00:00	2014,05,10,删除,饭小烟,18,男神,21,第四集,喜欢,大爱,ed,34,20,小组,只信,信命,com
2790	2014-05-29 20:52:37.603769	http://www.douban.com/group/topic/52790785/	公开课推荐好书（含下载） - 豆瓣	《极客与怪杰：领导是怎样炼成的》 （完整版） 《用心法则改变你一生的关键》艾伦.南格 城通: zxcdream.400gb.com 百度: pan.baidu.com/s/1pJ0kHHD. 2人 喜欢 喜欢.	\N	0	0	0	0	3	2014-05-15 00:00:00	公开课,05,小组,早道,06,04,03,02,01,幸福,日语,com,15,推荐,登录,下载,汇总,极客,怪杰
2787	2014-05-29 20:52:37.578765	http://www.douban.com/people/52616520/	幽篁坐啸 - 豆瓣	百度网盘： http://pan.baidu.com/share/home?uk=1913128246#category/type=0 以上网盘分享资料用途均参见小站奶爸的英语教室http://site.douban.com/195274/	\N	1	0	0	0	3	2014-05-13 00:00:00	middot,幽篁,com,坐啸,http,奶爸,2014,英语,小站,...,douban,05,分享,gt,资源,更新,教室,site
2791	2014-05-29 20:52:37.612106	http://www.douban.com/group/topic/52183842/	有听前世今生很多遍而毫无感觉的吗？ - 豆瓣	可以试试这个，不是廖阅鹏的催眠： 链接: http://pan.baidu.com/s/1d7O8A 密码: 75ro 可以试试这个，不是廖阅鹏的催眠： 链接: http://pan.baidu.com/s/1d7O8A 密码: ...	\N	1	0	0	0	3	2014-05-01 00:00:00	2014,05,删除,08,22,01,蜜桃,前世,催眠,腹黑,流浪,天蝎,...,小姐,09,11,02,远离,白光
2782	2014-05-29 20:52:37.537049	http://www.douban.com/group/topic/52909989/	跳完头晕想吐还要继续么？ - 豆瓣	... 2014-05-19 00:43:14. 多谢，在网上哪里有教程？ 多谢，在网上哪里有教程？ 重庆女巫. 百度搜一下就有或者在百度搜索栏打site:pan.baidu.com T25 看看找到不.	\N	0	0	0	0	3	2014-05-18 00:00:00	2014,05,删除,T25,女巫,一腿,柠柠,护膝,19,膝盖,世异时移,...,一笑置之,肌肉,重庆,淡淡,01,发麻
2802	2014-05-29 20:52:37.703818	http://www.douban.com/group/topic/53236535/	电脑装机必备安装包大全	下载地址：http://pan.baidu.com/s/1c0AHvkW 【2345装机必备软件软件特点】 1. 无毒、无插件，比在其他网站下载的更安全； 2. 可自定义软件安装目录； 3. 添加了第 ...	\N	1	0	0	0	3	2014-05-26 20:52:36.948581	装机必备,小组,QQ,2345,软件,com,2014,登录,电脑,大全,安装,安装包,插件,开心,输入法,视频,times,pan
2792	2014-05-29 20:52:37.620271	http://www.douban.com/photos/photo/2182196087/	福根儿的相册-我又被震惊了！！！！！！！！！【贰】 - 豆瓣	链接: http://pan.baidu.com/s/1pJsIOAn 密码: fq7i 迷途的羔羊. 链接: http://pan.baidu.com/s/1pJsIOAn 密码: fq7i 迷途的羔羊. 链接: http://pan.baidu.com/s/1pJsIOAn ...	\N	0	0	0	0	3	2014-05-07 00:00:00	05,gt,2014,07,删除,20,com,pan,http,fq7i,baidu,1pJsIOAn,08,链接,密码,好人,迷途,19,李小璐,羔羊
2786	2014-05-29 20:52:37.57043	http://www.douban.com/group/topic/52585983/	从霍出品的战长沙一路痴汉到大横店，相约一起看高清 - 豆瓣	http://pan.baidu.com/wap/link?shareid=2314608106&uk=4178298268&third=0&amp;page=1 lz私心的求一下哪位高人有霍出品的吻戏剪辑 排不上横店大军，当 ...	\N	1	0	0	0	3	2014-05-10 00:00:00	05,2014,11,00,删除,惹人爱,圆圆,amp,10,23,姐夫,01,com,pan,baidu,Blabla,圆房,http,...
2789	2014-05-29 20:52:37.59544	http://www.douban.com/group/topic/52213324/	s7 720P 百度云~【e24已更新】 - 豆瓣	http://pan.baidu.com/s/1ntNoPdR s7e22 蓝后有木有姿势大帝告诉下除了有土逼还有什么网站可以看tbbt。。。翻出去之后表示不知该往哪走	\N	1	0	0	0	3	2014-05-02 00:00:00	2014,05,删除,馒头,12,半个,19,晚安,Penny,...,Landy,02,天亮,爱是,溺人,23,22,17,14
2831	2014-05-29 20:53:19.343738	http://site.douban.com/audionet/	audionet的小站（豆瓣音乐人）	视频教程下载. Adobe Audition 3.0 视频教程 · http://pan.baidu.com/s/1gduu2VT 密码:6ulq. Adobe Audition CS6 视频教程 · http://pan.baidu.com/s/1pJz3PQb 密码: ...	\N	2	0	0	0	3	2014-05-08 00:00:00	下载,视频教程,com,audionet,&#,本站,音乐,http,小站,效果器,资源,播放,pan,javascript,douban,baidu,Audition,Adobe,浏览器
2798	2014-05-29 20:52:37.670482	http://www.douban.com/group/topic/52442356/	摄影杂志网盘分享 - 豆瓣	最新杂志下载唯一无水印百度网盘下载站. Body lines2014年第1期18禁人体摄影杂志 链接: http://pan.baidu.com/s/1jGqlj1O 密码: em27. Black + White Photography ...	\N	2	0	0	0	3	2014-05-07 00:00:00	http,2014,小组,杂志,com,登录,摄影,网盘,人体摄影,viewthrea,um,times,tid,shiyue,php,pan,mod,baidu
2797	2014-05-29 20:52:37.661974	http://www.douban.com/group/topic/53089224/	托福TPO33出来了，分享给大家托福模考软件破解版！... - 豆瓣	... 托福模考软件破解版。要下载的抓紧时间下吧，百度网盘最近不稳定说不定哪天就被删掉了。 下载地址： windows版本下载地址：http://pan.baidu.com/s/1qWjoglm	\N	2	0	0	0	3	2014-05-22 00:00:00	托福,2014,小组,破解版,模考,TPO33,05,分享,com,...,登录,英语,软件,下载,times,pan,lory523
2799	2014-05-29 20:52:37.678833	http://www.douban.com/group/topic/52442358/	摄影杂志网盘分享 - 豆瓣	最新杂志唯一无水印百度网盘下载. Body lines2014年第1期18禁人体摄影杂志 链接: http://pan.baidu.com/s/1jGqlj1O 密码: em27. Black + White Photography 2014 ...	\N	2	0	0	0	3	2014-05-07 00:00:00	http,2014,小组,杂志,com,登录,摄影,网盘,人体摄影,viewthrea,um,times,tid,shiyue,php,pan,mod,baidu
2794	2014-05-29 20:52:37.63697	http://www.douban.com/group/topic/53306853/	20140528资料重新分享，逐步修复下载链接~	链接: http://pan.baidu.com/s/1pJ0lFM7 密码: clml ----------------------------------------------------------------------------- 1、妹尾河童-河童旅行素描本 2、妹尾河童-窥看欧洲	\N	2	0	0	0	3	2014-05-27 20:52:36.944754	2014,28,05,链接,小组,河童,旅行,删除,妹尾,com,09,登录,修复,分享,铅笔,素描,重新,闲余
2813	2014-05-29 20:52:37.795392	http://movie.douban.com/subject/22523273/discussion/57746368/	婚礼上的小提琴配乐完整MP3下载分享！ - 豆瓣电影	感谢@Listmaniac 同学提供的歌曲名称和youtube的在线地址~~~. 听到这首歌就会想到cam和mitch的一幕幕啊有木有！！！ 好好享受吧~！ http://pan.baidu.com/s/ ...	\N	0	0	0	0	3	2014-05-22 00:00:00	gt,2014,05,middot,删除,24,23,13,首歌,分享,电影,小提琴,com,ananny,MP3,25,22,19,16
2809	2014-05-29 20:52:37.762007	http://movie.douban.com/subject/24705628/discussion/57591441/	自己剪辑的里面的铃声。喜欢的可以下载。 - 豆瓣电影	自己剪辑的里面的铃声。喜欢的可以下载。 小韩某生 (北京) 2014-05-08 15:18:42. http://pan.baidu.com/s/1hqgLQKW. 分享到. 推荐 · > 我来回应. > 寻第一季的全部 ...	\N	0	0	0	0	3	2014-05-08 00:00:00	middot,gt,2014,铃声,电影,com,第一季,影评,剪辑,电视剧,下载,巴特利,海格,手机,格罗夫,巴比特,詹米,穆雷,猪脚
2807	2014-05-29 20:52:37.745343	http://www.douban.com/group/topic/52367762/	喜欢看欧美电影的童鞋求打包带走··， - 豆瓣	特意拿来和大家分享的··. 需要的朋友可以去我的朋友圈下载我的薇信zyy0200（不注明的不加不想收到陌生人的骚扰） 链接: http://pan。baidu。com/s/1i3hzF1r. 喜欢.	\N	0	0	0	0	3	2014-05-06 00:00:00	小组,喜欢,电影,登录,童鞋,打包带,times,com,2014,注册,推荐,看过,欧美,话题,王大卫,朋友圈,手机,飞波
2817	2014-05-29 20:52:37.828672	http://www.douban.com/group/topic/53208607/	有没有好听的歌啊~求推荐啊 - 豆瓣	果然是老歌，只追求好听的歌，现在去唱k都是怎么老歌怎么点了。 蛋蛋酱°. 链接: http://pan.baidu.com/s/1sj8oQID 密码: f3yf 发给你我收藏的其中一个音乐资源。	\N	1	0	0	0	3	2014-05-25 20:52:36.955773	2014,05,25,删除,蛋蛋,不敢,灰灰,17,16,26,22,大眼萌,老歌,浪浪,23,喜欢,凌秋,reckless
2805	2014-05-29 20:52:37.728855	http://www.douban.com/thing/101/?on=1050661	育儿 - 豆瓣	2 喜欢. 取名软件哪个好？ [攻略]. 宝宝取名软件注册版免费下载宝宝取名大师软件V23.0免费版下载http://pan.baidu.com/s/1h8fge 最新周易起名大师15.0免费版 ...	\N	0	0	0	0	3	2014-05-29 05:52:36.950033	......,喜欢,孩子,攻略,育儿,宝宝,com,http,妈妈,幼儿园,免费版,pan,baidu,取名,楼主,软件,下载
2810	2014-05-29 20:52:37.770338	http://www.douban.com/group/topic/52561473/	2014年国家司法考试三大本电子版整理 - 豆瓣	需要的可以去我的百度网盘里面下载，地址我留下，你们复制粘贴到浏览器即可下载（pan.baidu.com/s/1o6wNQJ4） 这些书本是我从一个朋友那里得到了，如果对你们 ...	\N	0	0	0	0	3	2014-05-10 00:00:00	2014,司法考试,小组,电子版,真题,三大本,登录,试卷,冲刺,times,com,11,...,注册,楼主,章节,整理,历年
2808	2014-05-29 20:52:37.753668	http://www.douban.com/group/topic/52307718/	SBS新综艺Roommate～ - 豆瓣	140504. 中字下载地址：http://pan.baidu.com/s/1bnCdYu7?qq-pf-to=pcqq.group 140511 第二期中字在线地址：. [11站联合][Roommate][E002_140511][KO_CN].	\N	2	0	0	0	3	2014-05-05 00:00:00	05,2014,删除,迪欧,哈特,15,中字,01,春儿,12,灿烈,http,com,17,李东旭,期待,18,06,朴春
2815	2014-05-29 20:52:37.812058	http://www.douban.com/group/topic/52189338/	Spahn Ranch - Thickly Settled (1987) - 豆瓣	fabiano 2014-05-02 00:51:08. pan.baidu.com/s/1qWJeYkc. 删除. 赞 回应. 你的回应. 回应请先登录 , 或注册. 推荐到广播. This is Just A Modern Rock Song. 1164 人 ...	\N	0	0	0	0	3	2014-05-01 00:00:00	fabiano,小组,&#,com,Thickly,Spahn,Settled,Ranch,2014,登录,times,music,douban,band,Odell,90,34
2806	2014-05-29 20:52:37.737179	http://www.douban.com/group/topic/52520857/	免费赠送电子书咯。 - 豆瓣	来自: 我飞天梦 2014-05-09 12:52:53. 链接: http://pan.baidu.com/s/1bn7ux7T 密码: btyb穿越小说合集 链接: http://pan.baidu.com/s/1pJuKHXh 密码: tsvf玄幻小说.	\N	2	0	0	0	3	2014-05-09 00:00:00	05,2014,删除,15,13,12,17,10,14,18,16,楼主,浩淼,22,19,24,21,11,20
2804	2014-05-29 20:52:37.72051	http://www.douban.com/group/topic/53215684/	求S05 E24 最后meth 和cam 婚礼现场的配乐 - 豆瓣	Home -- Edward Sharpe & The Magnetic Zeros http://www.xiami.com/song/1769004508 小提琴版-- VSQ http://pan.baidu.com/s/1bnvPTzp. 删除. 赞 回应 ...	\N	1	0	0	0	3	2014-05-25 20:52:36.94955	2014,05,配乐,Normally,com,删除,欧尼,我要,http,26,小组,冰毒,拼错,同求,xiami,www,song,meth
2796	2014-05-29 20:52:37.653815	http://www.douban.com/group/topic/52442758/	把我脸看红了 - 豆瓣	http://pan.baidu.com/s/1o6x46F4 要看趁早，马上被河蟹的，请叫我雷锋。 http://pan.baidu.com/s/1o6x46F4 要看趁早，马上被河蟹的，请叫我雷锋。 西门糯夫.	\N	3	0	0	0	3	2014-05-07 00:00:00	05,2014,07,17,删除,亲爱,21,com,pan,http,baidu,18,李小璐,雷锋,糯夫,solo,98,1o6x46F4,19
2811	2014-05-29 20:52:37.778682	http://movie.douban.com/subject/23232876/episode/5/?discussion_start=30	权力的游戏第四季Game of Thrones Season 4 第5集托曼一世	你咬我啊 10小时之前. 我的天都是小指头一手操控的.. 0 有用 0回应. 草草 10小时之前. http://pan.baidu.com/s/1qWjnodQ 可以看了 0 有用 0回应. Fever 10小时之前.	\N	0	0	0	0	3	2014-05-04 00:00:00	21,22,第四季,狼家,托曼,bran,游戏,电影,阿亚,电视剧,权力,指头,狼灵,virginqueen,gt
2816	2014-05-29 20:52:37.820334	http://www.douban.com/group/topic/45956223/?author=1	BBC、NHK纪录片分享【百度盘】 - 豆瓣	链接: http://pan.baidu.com/s/1D2pOU 密码: u99k -------------------------------------2014.05.14--------------------------------------- 又被河蟹掉了，NHK的文件暂时下不了，但是 ...	\N	1	0	0	0	3	2014-05-26 20:52:36.95529	骨碌,NHK,today,BBC,2014,删除,分享,小组,14,11,纪录片,com,02,30,05,喜欢,低俗,http
2812	2014-05-29 20:52:37.787006	http://www.douban.com/group/topic/52498274/	沈志华中山大学等讲座两枚下载 - 豆瓣	斯大林与冷战的起源中山大学 下载：http://pan.baidu.com/s/11WLWi 东方历史大讲堂朝鲜战争的起源—髦，斯大林与金日成的是是非非 下载：http://pan.baidu.com/s/ ...	\N	2	0	0	0	3	2014-05-08 00:00:00	小组,讲座,沈志华,怪奇,com,2014,登录,下载,居士,中山大学,times,pan,http,baidu,20,08,05,注册
2814	2014-05-29 20:52:37.803716	http://www.douban.com/group/topic/52137105/	2014深圳草莓音乐节招募志愿者 - 豆瓣	http://pan.baidu.com/s/1sj6QViH 报名联系人：周小姐/0755-89562720 邮件主题：#草莓志愿者#XXX应聘深圳草莓音乐节志愿者； 附件报名表命名：XXX（姓名）+手机 ...	\N	2	0	0	0	3	2014-04-30 00:00:00	志愿者,音乐节,2014,小组,工作,草莓,深圳,负责人,义工,现场,com,时间,报名表,通知,邮件,报名,17,主办方,培训
2803	2014-05-29 20:52:37.712194	http://www.douban.com/group/topic/52527647/	各类小说合集免费赠送，小伙伴们速度来打包.. - 豆瓣	来自: 摩托大王 2014-05-09 15:08:16. 链接: http://pan.baidu.com/s/1sjvw9OT 密码: c3x5英语短篇小说精品 链接: http://pan.baidu.com/s/1gdeLYV5 密码: fz83英文 ...	\N	2	0	0	0	3	2014-05-09 00:00:00	05,2014,删除,16,18,17,14,15,11,真爱才,无聊,24,22,21,01,20,19,张小娟,27
2778	2014-05-29 20:52:37.503725	http://movie.douban.com/people/tjz230/wish	芙蓉镇上影志叔想看的电影(1520) - 豆瓣电影	2014-04-25; pan.baidu.com/s/1jFsj8（中字Web版720p，密码y2hf） ，http://t.cn/8sKW5Cs 密码: hc6k. Bébé(s). 阳光宝贝/ Bébé(s) / 五洲婴儿/ 宝贝; 2010-06-16(法国) ...	\N	0	0	0	0	3	2014-05-04 00:00:00	2014,05,http,2013,com,剧情,04,分钟,电影,middot,html,23,英语,标签,同性,25,11,xunleihao,oumeidianying
2781	2014-05-29 20:52:37.528543	http://www.douban.com/group/topic/32619772/?start=700	【网盘好了继续发邮箱】绘画资料放送ing 有... - 豆瓣	... 水彩童话绘本插画教程是哪本？ 谢谢楼主，请问水彩童话绘本插画教程是哪本？ taikobo · http://pan.baidu.com/share/link?shareid=4224075212&uk=654329891.	\N	2	0	0	0	3	2014-05-08 00:00:00	2014,删除,com,楼主,08,2013,qq,03,05,21,谢谢,16,04,忘川,22,12,uk,shareid,share
2777	2014-05-29 20:52:37.495406	http://www.douban.com/group/topic/52423344/	【已更新】吐血分享最新化妆教程 - 豆瓣	流行美经典盘发http://pan.baidu.com/s/1qWK0PAW 2.全部化妆教程http://pan.baidu.com/s/1jGwW4j8 3.美甲个人形象设计http://pan.baidu.com/s/1pJFdjL5 · 喜欢.	\N	3	0	0	0	3	2014-05-07 00:00:00	2014,05,见笑,删除,..,小组,邮箱,com,22,11,10,09,08,07,pan,http,baidu
2780	2014-05-29 20:52:37.520216	http://www.douban.com/group/topic/52609249/	百度盘分享Mobi书籍 - 豆瓣	前段时间严打，百度盘里的mobi电子书都屏蔽掉 现在重新分享一下，希望有所帮助。 百度盘又屏蔽掉了，分享账户密码好了： http://pan.baidu.com/disk/home	\N	4	0	0	0	3	2014-05-11 00:00:00	05,2014,删除,楼主,14,12,13,11,rocky,分享,PRESENT,MAO,LOVE,25,17,密码,22,19,18
2835	2014-05-29 20:53:19.377064	http://www.douban.com/group/topic/52728328/	英语短篇小说精品和英文小说原著	链接: http://pan.baidu.com/s/1sjvw9OT 英语短篇小说精品 链接: http://pan.baidu.com/s/1gdeLYV5 英文小说原著 需要的朋友可以去我的朋友圈742715260. 3人 喜欢 ...	\N	2	0	0	0	3	2014-05-14 00:00:00	05,2014,删除,雪落,陌上,16,18,17,15,依然,14,12,22,21,19,10,23,楼主,26
2830	2014-05-29 20:53:19.335355	http://www.douban.com/group/topic/52749860/	蒸个男女朋友，送红米note F码 - 豆瓣	安卓下载地址：http://pan.baidu.com/s/1hqKHHRm （点普通下载就不用装网盘了！） 奖品设置： 一等奖：红米note F码，共2个 二等奖：爱秀SH-500耳机，共1个 三等奖： ...	\N	2	0	0	0	3	2014-05-14 00:00:00	2014,05,微聚,勾搭,19,删除,16,15,酱香,KO,23077040,22945117,14,自来,12,30,11,54
2828	2014-05-29 20:53:19.318686	http://www.douban.com/people/xryutu/	祥瑞御兔 - 豆瓣	留言板 · · · · · · ( 全部 ). 祥瑞御兔: http://pan.baidu.com/share/home?uk=490155926&view=share#category/type=0 04-18 21:40. 櫻華夢到秀川君: ...	\N	2	0	0	0	3	2014-05-14 00:00:00	middot,http,com,www,html,御兔,祥瑞,cn,sina,douban,04,amp,ish,iask,2014,folderid,page,index
2818	2014-05-29 20:53:19.229258	http://www.douban.com/group/topic/53047596/	【问路】胡话，斯万维克与莱斯尼克，以及SciFiWiKi	恢复网站 幻译居的数据文件随便下载：http://pan.baidu.com/s/1gdKcogz 有一千多条记录了吧。恢复网站比较难，空间是一方面，我自己写的asp代码比较陈旧，需要有 ...	\N	2	0	0	0	3	2014-05-21 00:00:00	斯尼克,维克,迈克尔,斯万,科幻,http,SF,2014,05,迈克,com,幻译,21,科幻世界,删除,期刊,ctsffdb,博览,科幻小说
2856	2014-05-29 20:53:19.55219	http://www.douban.com/thing/96/experience/1085065/	时间管理笔记分享-ONENOTE/EVERNOTE格式 - 豆瓣	个人提升：http://pan.baidu.com/s/1pJi9ogV 目录截图A 目录截图B 同时也分享了一些别的笔记。 http://www.douban.com/note/348754358/ ...	\N	1	0	0	0	3	2014-05-03 00:00:00	com,http,ONENOTE,EVERNOTE,douban,www,截图,2014,05,03,喜欢,分享,目录,笔记,topic,pan,note,group,baidu
2999	2014-05-29 20:53:52.607971	http://movie.douban.com/subject/23286078/comments	不安的种子短评 - 豆瓣电影	1 有用 一枚头像 2014-04-28. http://pan.baidu.com/play/video#video/path=%2FPet.Peeve.2013.DVDRip.x264.AC3-GDK.mkv&t=-1 ...	\N	0	0	0	0	3	2014-05-02 00:00:00	2014,05,04,漫画,恐怖,电影,29,01,不安,短评,恐怖片,时空,诡异,故事,映画化,gt,167,11
2750	2014-05-29 20:52:37.245238	http://www.douban.com/group/topic/52715924/	经济学人杂志1998-2014年电子文档和英语语音版下载... - 豆瓣	5、这是我最喜欢的游记作家bill bryson的全集，最新的one summer没有，请大家珍惜。 http://pan.baidu.com/share/link?shareid=413020&uk=808823869#dir 6.	\N	7	0	0	0	3	2014-05-13 00:00:00	2014,语音版,英语,05,http,本书,咕嘟,com,删除,pan,baidu,21,杂志,uk,shareid,share,amp,13
2768	2014-05-29 20:52:37.39534	http://site.douban.com/jfbooksclub/room/442577/	季风书讯(上海季风书园读书俱乐部的小站) - 豆瓣	季风书园: 2013年度特刊（NO.338）推荐好书30本豆列：http://book.douban.com/doulist/3445135/；年度特刊下载地址：http://pan.baidu.com/s/1gdBSXVX 01-17 15: ...	\N	10	0	0	0	3	2014-05-08 00:00:00	http,季风,NO,书讯,书园,com,17,新书,pan,baidu,douban,om,doulist,book,15,01,编后,下载,豆列,2014
2766	2014-05-29 20:52:37.37867	http://www.douban.com/group/topic/53249809/	中级-2014年中级的课件资料免费下载-百度网盘,更新中	会计：http://pan.baidu.com/s/1o68ZXAq密码:jowe 中级Q群：295667569 202337958 297614190 加群请写优会计网 提醒下：很多人假装免费实际上是收费，比如需要 ...	\N	3	0	0	0	3	2014-05-26 20:52:36.931326	2014,05,com,中级,小组,26,课件,楼主,会计,百度网,删除,会计网,pan,http,baidu,资料,登录,感谢
2759	2014-05-29 20:52:37.320266	http://www.douban.com/group/topic/53183387/	求Paul Theroux、Jorge Luis Borges 的书和LP等旅游书 - 豆瓣	... Borges http://kickass.to/usearch/Jorge Luis Borges/ Lonely Planet http://pan.baidu.com/share/link?shareid=528635&uk=2553635153 · http://so.baiduyun.me/.	\N	1	0	0	0	3	2014-05-24 20:52:36.927978	http,Theroux,Paul,Luis,Jorge,Borges,kickass,com,小组,2014,05,usearch,LP,...,登录,初体验,uk
2765	2014-05-29 20:52:37.370349	http://www.douban.com/thing/101/experience/1089855/	取名软件哪个好？ - 豆瓣	宝宝取名软件注册版免费下载宝宝取名大师软件V23.0免费版下载http://pan.baidu.com/s/1h8fge 最新周易起名大师15.0免费版 ...	\N	4	0	0	0	3	2014-05-13 00:00:00	起名,宝宝,取名,软件,马年,名字,com,http,pan,baidu,amp,寓意,2014,免费版,下载,字根,属马,宜用,五行,周易
2760	2014-05-29 20:52:37.328617	http://movie.douban.com/doulist/1423947/	日本电影存档 - 豆瓣电影	梦幻银河ユメノ銀河. 导演: 石井聰亙 主演: 小嶺麗奈/浅野忠信/真野きりな. 评语 : http://pan.baidu.com/share/link?shareid=322532&uk=1378409010 字幕：anj9vtzs# ...	\N	0	0	0	0	3	2014-05-10 00:00:00	主演,导演,评语,middot,com,http,amp,2013,13,电影,胡茵梦,xunlei,水島裕子,pan,kuai,file,baidu,Emoto,19
2753	2014-05-29 20:52:37.270294	http://www.douban.com/group/topic/52246987/	【资源】5-13更新·关于手帐和文具的笔记(个人收集) - 豆瓣	关于EVERNOTE的使用，可以看这本书： http://pan.baidu.com/s/1qWAXI2o 密码: e4g8 还有两个资料包也顺便放出来，ONENOTE2010格式的。在这里：	\N	5	0	0	0	3	2014-05-03 00:00:00	05,2014,删除,楼主,04,露珠,21,08,03,谢谢,09,07,06,导入,23,10,22,01,下载
2754	2014-05-29 20:52:37.278827	http://www.douban.com/group/topic/52171526/	【曝惊人内幕】原来网购还能这样返现！！！长见识... - 豆瓣	http://pan.baidu.com/s/1jGG9spS · http://pan.baidu.com/s/1c0f7Ozu · http://pan.baidu.com/share/home?uk=3812662438#category/type=0. 删除. 赞 回应 ...	\N	4	0	0	0	3	2014-05-01 00:00:00	返现,网购,com,2014,05,小组,pan,http,baidu,...,登录,长见识,times,murray0799,gerald815,37,16,01
2749	2014-05-29 20:52:37.236915	http://site.douban.com/205154/	Adventure time的小站 - 豆瓣	全季下载链接（整理更新中）: http://pan.baidu.com/s/1qW2jMJq 密码: s4dr. Season 5 720P全集生肉下载：http://pan.baidu.com/s/1dDejUEl 推广： Adventure Time ...	\N	2	0	0	0	3	2014-05-10 00:00:00	43,&#,http,Adventure,com,我来,gt,dou,bz,time,26,小站,关注,五月,Time,小豆,全季,quot
2832	2014-05-29 20:53:19.352055	http://www.douban.com/group/topic/52441899/	瑜伽各类经典教程，喜欢瑜伽的，去下载吧 - 豆瓣	我的网盘：http://pan.baidu.com/s/1kTmevaf 加我V信zyy0200. 第二：还是自己去下载！地址在这里哈！我的网盘：http://pan.baidu.com/s/1kTmevaf 加我V信zyy0200.	\N	1	0	0	0	3	2014-05-07 00:00:00	05,2014,删除,14,16,13,15,11,12,17,10,18,09,24,21,19,楼主,08,墙上
2744	2014-05-29 20:52:37.195233	http://www.douban.com/group/topic/52280979/	【减肥书籍电子书分享】 - 豆瓣	田中宥久子的美体按摩法 链接：http://pan.baidu.com/s/1i3gdDYH 密码：wk070 瑜伽功法全书 链接：http://pan.baidu.com/s/1kTHTpYZ 密码：wvz70 塑身女王教你打造 ...	\N	7	0	0	0	3	2014-05-04 00:00:00	05,2014,04,删除,谢谢,楼主,21,道理,20,19,17,10,支持,18,卡哇伊,分享,挺住,我素,我性
2820	2014-05-29 20:53:19.252083	http://www.douban.com/people/finix2011/	爱卢梭的Felix - 豆瓣	爱卢梭的Felix创建的集哲学、德语、法语资料于一处的百度云盘地址（公益学习型项目【爱智慧学园】 学习资料分享中心）：http://pan.baidu.com/share/home?uk= ...	\N	3	0	0	0	3	2014-05-18 00:00:00	middot,Felix,卢梭,com,http,QQ,11,德语,2014,哲学,学园,法语,云盘,uk,share,pan,home,baidu,大学
2887	2014-05-29 20:53:19.835871	http://www.douban.com/group/topic/53053219/	史上最牛逼的考研微信工具，没有之一，看图，我什... - 豆瓣	完全公益： 最全最给力的课件地址：http://pan.baidu.com/s/1mgqhT8G （请尽快保存到自己网盘哦） 更多免费增值服务请关注微信号：woyaoduoyan 或新浪微博：夺研。	\N	1	0	0	0	3	2014-05-21 00:00:00	研友,2014,微信,考研,MM,05,语音,美不美,http,说了算,删除,夺研,woyaoduoyan,com,...,小组,随机,签到
2915	2014-05-29 20:53:20.069353	http://www.douban.com/group/topic/52419894/	凉爽一夏【冰淇淋教程教学免费分享】 - 豆瓣	http://pan.baidu.com/s/1jGt8SSI 有喜欢的亲们可以留下你们的邮箱我 看到了会一一下发的，捉急的朋友可以直接加我v信yyu500113我分享在朋友 圈里的哦	\N	1	0	0	0	3	2014-05-07 00:00:00	冰淇淋,小组,教程,2014,喜欢,登录,凉爽,一夏,times,com,07,05,...,分享,注册,冷饮,各式,教学
2845	2014-05-29 20:53:19.46061	http://www.douban.com/group/topic/52640324/	摄影视频ppt教程 - 豆瓣	链接: http://pan.baidu.com/s/1hqKHzEG 摄影基础课件教程 链接: http://pan.baidu.com/s/1kTA1VO7 摄影用光基础 需要的朋友加我zyy0200. 喜欢 · 回应 推荐 喜欢 只 ...	\N	2	0	0	0	3	2014-05-12 00:00:00	小组,com,登录,摄影,教程,爱普生,times,ppt,pan,http,baidu,2014,注册,画画,链接,喜欢,视频,话题
2919	2014-05-29 20:53:51.907813	http://www.douban.com/group/topic/52383604/	摄影教程.喜欢摄影的朋友过来围观咯， - 豆瓣	豆友需要的，+我微信；zyy0200 我慢慢会分享在朋友圈给大家！ 链接: http://pan.baidu.com/s/1o67DJAU. 豆友需要的，+我微信；zyy0200 我慢慢会分享在朋友圈给 ...	\N	0	0	0	0	3	2014-05-06 00:00:00	\N
2921	2014-05-29 20:53:51.924124	http://www.douban.com/group/topic/52442517/	最新【Excel】资料汇总 - 豆瓣	非常不错的Excel资料哦。。整理了好久呢。 地址放这啦,想要的来拿吧。 http://pan.baidu.com/s/1qWLMYfy ^^提取码请加威信5963381 获取^^ 加我时发送验证“excel” ...	\N	0	0	0	0	3	2014-05-07 00:00:00	\N
2923	2014-05-29 20:53:51.940793	http://www.douban.com/group/topic/52477514/	学摄影视频教程，想要的速度来了 - 豆瓣	来自: 天黑适合杀人 2014-05-08 12:34:13. 这是地址链接， : http://pan.baidu.com/s/1mgkbw3e 要的朋友可以加我的微信zyy0200，加的时候要注明，摄影素材密码啊 ...	\N	0	0	0	0	3	2014-05-08 00:00:00	\N
2928	2014-05-29 20:53:51.982576	http://www.douban.com/group/topic/52302950/	大婶一分钟变正妹 - 豆瓣	大婶一分钟变正妹..... 你想学吗？ 我有《彩妆天王Kevin裸妆圣经》 链接: http://pan.baidu.com/s/1gdyyChH 下载密码: 加薇信aacn92 索取 我是一个专业的肌肤护理/ ...	\N	0	0	0	0	3	2014-05-04 00:00:00	\N
2932	2014-05-29 20:53:52.015934	http://www.douban.com/group/topic/52900119/	最新Google Nik Collection 1.2.0.3 滤镜集 - 豆瓣	下载：http://pan.baidu.com/s/1nt3CJCP. Nik Collection(尼康专业图象处理套装软件)全套有6 款强大的图像处理插件，分别为Color Efex Pro 4(图像调色滤镜)、HDR ...	\N	0	0	0	0	3	2014-05-18 00:00:00	\N
2934	2014-05-29 20:53:52.032607	http://www.douban.com/group/topic/52425226/	免费赠送法语教程啦。。。。赶紧来抢啊，，，仅限... - 豆瓣	... 豆豆们赶紧来抢啦，，，仅限50名哦，，，不然会引起公愤啦。。。。。免费送，只希望和各位奋斗中的豆豆们交个朋友，，仅此而已，， http://pan.baidu.com/s/1kTwoAcZ	\N	0	0	0	0	3	2014-05-07 00:00:00	\N
2936	2014-05-29 20:53:52.049275	http://www.douban.com/group/topic/52384705/	哈哈哈，给豆友们送书咯，速度来啊··· - 豆瓣	... 还有很多其他学习的资源哦。，. 需要的朋友可以去我的朋友圈下载我的薇信zyy0200（不注明的不加不想收到陌生人的骚扰） 链接: http://pan.baidu.com/s/1bnktFdl.	\N	0	0	0	0	3	2014-05-06 00:00:00	\N
2920	2014-05-29 20:53:51.915822	http://music.douban.com/review/6669436/	Lindsey Stirling - Shatter Me（Classical Crossover ... - 豆瓣音乐	Free Download: http://pan.baidu.com/s/1bnw5xEJ（320kbs） 原创授权内容禁止转载. 你认为这篇评论： 有用 没用. 分享到. 推荐 · > 我来回应. 本评论版权属于作者自 ...	\N	0	0	0	0	3	2014-05-14 00:00:00	quot,Stirling,song,album,songs,Shatter,Me,track,middot,Lindsey,10,评论,自闭症,vocals
2935	2014-05-29 20:53:52.040962	http://www.douban.com/group/topic/52902625/	【发福利】史上最长久的德语+法语+哲学资料（2014... - 豆瓣	... 语和拉丁语资料以培养更多的研究型人才），所以趁着把这些好的德语、法语、哲学材料给他们的同时也把链接（http://pan.baidu.com/share/home?uk=2450455396 ...	\N	1	0	0	0	3	2014-05-18 00:00:00	德语,法语,哲学,pdf,doc,2014,资料,学习,课程,上传,笔记,朋友,云盘,com,讲座,史上,最全,录音,分享
2925	2014-05-29 20:53:51.957535	http://www.douban.com/group/topic/52565305/	八月炮火，guns of august英语语音版下载链接 - 豆瓣	此书我看过，八月炮火，guns of august英语语音版下载链接 链接：http://pan.baidu.com/s/1i3khGot 密码：rh2l 塔奇曼的名著，切下且珍惜。建议购买中文译本，听英语 ...	\N	1	0	0	0	3	2014-05-10 00:00:00	英语,小组,语音版,guns,august,链接,登录,有声,炮火,times,com,Audiobook,2014,英文,八月,原版,注册,下载
2922	2014-05-29 20:53:51.932324	http://www.douban.com/group/topic/52440690/	欧美经典电影音乐200首，求带走 - 豆瓣	... 圈下载我的薇信zyy0200（不注明的不加不想收到陌生人的骚扰） 还有很多的学习素材哈，与你们分享，结交更多的朋友。 链接: http://pan.baidu。com/s/1B0g70..	\N	0	0	0	0	3	2014-05-07 00:00:00	05,2014,删除,14,11,17,泥中,1970,16,15,22,21,18,26,13,09,19,10,莲花
2924	2014-05-29 20:53:51.949197	http://www.douban.com/group/topic/52389609/?type=rec	试着回答你的任何问题	各领域经典书籍推荐http://pan.baidu.com/s/1eQ46J54 闲尘居的普世价值观http://www.douban.com/group/topic/52596919/ 开此贴后的一些说明2014-5-9 ...	\N	1	0	0	0	3	2014-05-06 00:00:00	http,douban,www,group,2014,topic,小组,quot,试着,39,回答,登录,times,com,31,17,书籍,基本知识
2929	2014-05-29 20:53:51.990926	http://www.douban.com/group/topic/52798552/	【广州招聘】招【创意总监】【平面设计总监】【美... - 豆瓣	薪酬待遇：面谈 联系方式：leftjobs@yeah.net 请应聘者在下面地址下载一份问卷，并将回答、联系方式及简历发送到上面的邮箱中 http://pan.baidu.com/s/1hqA5GtY.	\N	1	0	0	0	3	2014-05-15 00:00:00	创意,总监,平面设计,小组,...,熟练,能力,登录,经验,提案,整件事,指导,招聘,times,com,2014,建筑,英文,优先
2926	2014-05-29 20:53:51.965991	http://www.douban.com/group/topic/53033095/	莎翁名剧学习材料 - 豆瓣	粉丝团体“抖森翻译军团”根据朱生豪译本提供的中文字幕。虽然没有卷福，却有卷福他哥友情客串。度盘自取，过期不候。 链接: http://pan.baidu.com/s/1kTr5Jmf 密码: ...	\N	1	0	0	0	3	2014-05-21 00:00:00	2014,05,21,删除,小组,...,莎翁,10,多谢,登录,抖森,卷福,times,com,Hua,HANA,42,31
2918	2014-05-29 20:53:51.885959	http://www.douban.com/group/topic/52421759/	赠送免费电子书，结交天下好朋友。 - 豆瓣	需要的朋友可以去我的朋友圈下载我的薇信zyy0200（不注明的不加不想收到陌生人的骚扰） 链接: http://pan.baidu.com/s/1bnktFdl 如果觉得可以的话，下载的朋友们 ...	\N	1	0	0	0	3	2014-05-07 00:00:00	05,2014,删除,14,15,楼主,10,16,13,18,23,19,17,12,11,21,忠诚,22,09
2734	2014-05-29 20:52:37.111867	http://site.douban.com/218160/widget/notes/14423964/note/351707781/	作品资源下载汇总【20140519更新】 - 豆瓣	http://pan.baidu.com/s/1dDkqkLz p9ih 2012 Henry IV 2012 Absent Friends – Performer 2012 Swiftcover SwiftBrothers| Advertising Campaign- Voice Actor	\N	22	0	0	0	3	2014-05-17 00:00:00	http,com,Actor,pan,baidu,Performer,Gentlemen,League,2012,Writer,Local,douban,Theatre,Comedy,2007,2005,2002,2000,www,people
2735	2014-05-29 20:52:37.12024	http://movie.douban.com/subject/22523273/discussion/57742135/	跪求最后一集的最后的小提琴曲子名字谢谢 - 豆瓣电影	2014-05-25 20:32:18 黑妮. 小提琴版本的下载地址http://pan.baidu.com/s/1bnvPTzp 小提琴版本的下载地址http://pan.baidu.com/s/1bnvPTzp 云水襟怀. 非常的谢谢.	\N	1	0	0	0	3	2014-05-22 00:00:00	gt,2014,05,middot,20,删除,home,32,22,小提琴,黑妮,com,amp,25,谢谢,pan,http,baidu,Zeros
2742	2014-05-29 20:52:37.178488	http://www.douban.com/group/topic/28328254/?cid=391288117	【字幕专帖】 - 豆瓣	资料：http://movie.douban.com/subject/3427163/ 片源：http://pan.baidu.com/share/link?shareid=361708&uk=3439715702 是法语发音的，跪求各位大神翻译成 ...	\N	6	0	0	0	3	2014-05-19 00:00:00	http,com,movie,字幕,douban,subject,2013,删除,片源,2014,02,中文字幕,翻译,片名,20,03,www,amp,中字
2940	2014-05-29 20:53:52.082651	http://www.douban.com/group/topic/52385640/	【免费分享零基础粤语视频教程大全】！送给爱说粤... - 豆瓣	... 也有我的v信wanna_Daphne广告党勿扰 链接: http://pan.baidu.com/s/1hqmRusO，资料是我自己整理的，或是自己在网上买的，不喜勿喷，不要浪费我辛苦的资料。	\N	0	0	0	0	3	2014-05-06 00:00:00	\N
2943	2014-05-29 20:53:52.107674	http://www.douban.com/group/topic/52559809/	群里面有爱好心理学的可以打包下载走~ - 豆瓣	来自: 不装13的民工甲 2014-05-10 11:03:57. 这是链接：http://pan.baidu.com/s/1kTwoAcZ · 3人 喜欢 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	0	0	0	0	3	2014-05-10 00:00:00	\N
2946	2014-05-29 20:53:52.132664	http://www.douban.com/group/topic/52384721/	【免费分享零基础粤语视频教程大全】！送给爱说粤... - 豆瓣	链接: http://pan.baidu.com/s/1jGys69K 密码: gk6g这是其中一点，资料是我自己整理的，或是自己在网上买的，不喜勿喷，不要浪费我辛苦的资料。 谢谢！！！ 19人 ...	\N	0	0	0	0	3	2014-05-06 00:00:00	\N
2947	2014-05-29 20:53:52.141015	http://www.douban.com/group/topic/52558769/	【资源】 手帐手绘教程~~14本书哦~！！！ 有木有需... - 豆瓣	来自: 翟家佳 2014-05-10 10:34:27. 有需要的吗？？？ 希望大家能顶起来造福更多人哦 这是链接地址：http://pan.baidu.com/s/1ntuhMul · 3人 喜欢 喜欢 · 回应 推荐 ...	\N	0	0	0	0	3	2014-05-10 00:00:00	\N
2944	2014-05-29 20:53:52.115995	http://www.douban.com/group/topic/52724459/	杨银禄《我给江青当秘书》音频（部分） - 豆瓣	... 时间最长的一任秘书杨银禄讲述的“文革”时期的江青。 作者通过回忆记述了江青很多鲜为人知的生活细节，很值得一听。 下载：http://pan.baidu.com/s/1dD8C4N3.	\N	1	0	0	0	3	2014-05-14 00:00:00	江青,小组,杨银禄,怪奇,秘书,登录,音频,居士,讲座,times,com,2014,注册,钓鱼台,录音,喜欢,出版社,庭院
2941	2014-05-29 20:53:52.091004	http://www.douban.com/group/topic/53361538/	美式英语发音教程	来自: 猫猫 2014-05-29 14:02:18. 很不错推荐给大家，希望对发音问题的伙伴有帮助 链接: http://pan.baidu.com/s/1i39R1QH 要的在下面留言，我豆油密码给你. 喜欢.	\N	1	0	0	0	3	2014-05-29 13:53:51.847821	29,2014,05,删除,密码,16,小组,19,谢谢,39,...,登录,美式英语,发音,times,herafter,com,__
2938	2014-05-29 20:53:52.065994	http://www.douban.com/group/topic/52518365/	精品300本清晰彩绘英文原版绘本，免费分享。 - 豆瓣	来自: 潘恩纳斯 2014-05-09 11:45:06. 链接: http://pan.baidu.com/s/1qWjTwsO 300本清晰英文原版绘本. 9人 喜欢 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	1	0	0	0	3	2014-05-09 00:00:00	05,2014,删除,16,18,17,15,10,22,14,13,12,19,楼主,口语,微信,23,21,20
2937	2014-05-29 20:53:52.057625	http://www.douban.com/group/topic/52522612/	分享【零基础ps手绘速成视频教程】自己的言情女主角 - 豆瓣	来自: 05海经回忆 2014-05-09 13:33:46. 想要学习的朋友赶紧来看看哦~~~~. 这是链接地址加的时候请注明http://pan.baidu.com/s/1sjwI5rv · 3人 喜欢 喜欢.	\N	1	0	0	0	3	2014-05-09 00:00:00	05,2014,删除,15,13,楼主,14,18,12,16,19,24,22,11,10,23,17,09,PS
2942	2014-05-29 20:53:52.099321	http://www.douban.com/group/topic/53255885/	一本神奇的电子书	... 看看这么经典的大师著作呢？ 大多数的人看后都觉得受益匪浅 今天免费分享给大家，想要学习的自己去下载吧！ 免费下载地址：http://pan.baidu.com/s/1bnu4qWR.	\N	1	0	0	0	3	2014-05-26 20:53:51.848337	小组,登录,创业,神奇,自拍馆,池夏,times,com,2014,...,一本,电子书,注册,教程,免费,下载,互联网,话题
2945	2014-05-29 20:53:52.124378	http://www.douban.com/group/topic/52909041/	求原子物理学教材电子版，iask被查真的很痛苦啊 - 豆瓣	... 2014-05-19 09:41:42. 我本来还以为ls 吹, 没想到是真的, 比如说 http://pan.baidu.com/share/link?shareid=2917268207&uk=218397692&fid=1962290694. 删除.	\N	1	0	0	0	3	2014-05-18 00:00:00	2014,小组,19,05,com,登录,物理学,电子版,我要,times,iask,amp,Fang,09,删除,真的,注册,被查
2952	2014-05-29 20:53:52.182709	http://www.douban.com/group/topic/52639956/	王春辰《图像的政治与批评》 - 豆瓣	... 不识字，何故乱翻书“的所谓”文字狱“也有”图像狱“。讲者通过一幅幅图像揭示其与政治隐喻或者说所谓的”政治隐喻"的关系。 下载：http://pan.baidu.com/s/1ntFhJmD.	\N	1	0	0	0	3	2014-05-12 00:00:00	小组,图像,王春辰,怪奇,登录,居士,讲座,政治,times,com,2014,注册,批评,隐喻,录音,历史,话题,六便士
2939	2014-05-29 20:53:52.074343	http://www.douban.com/group/topic/52267973/	我為一個一款字體補了字來看看吧 - 豆瓣	无星无月无节操 2014-05-04 09:50:27. http://pan.baidu.com/s/1grU6y 喜歡的下載看一下. 删除. 赞 回应 · 无星无月无节操 2014-05-04 09:57:01. 製作了繁體字	\N	1	0	0	0	3	2014-05-04 00:00:00	2014,小组,无星,05,04,节操,標準,我為,09,登录,規範,改為,怨靈,字體,一個,times,com,01
2954	2014-05-29 20:53:52.19938	http://www.douban.com/group/topic/52564649/	恋爱心理学，要的留邮箱 - 豆瓣	文本.资料教程. 我先说下获取教程的渠道； 免费分享，喜欢的可以留邮箱，有时间会统一发过去的， 着急的可以去朋友圈下载. 链接: http://pan.baidu.com/s/1kT5cswZ.	\N	0	0	0	0	3	2014-05-10 00:00:00	\N
2956	2014-05-29 20:53:52.216047	http://www.douban.com/group/topic/52399275/	【免费分享零基础粤语视频教程大全】！送给爱唱粤... - 豆瓣	这是我教程http://pan.baidu.com/s/1hqmRusO里面有很多的视频教程 喜欢的朋友留下你们的邮箱，到时候我会全部发你们的， 有捉急的朋友可以直接加我微信，我 ...	\N	0	0	0	0	3	2014-05-06 00:00:00	\N
2960	2014-05-29 20:53:52.249503	http://www.douban.com/group/topic/52385789/	【免费分享零基础粤语视频教程大全】！送给爱唱粤... - 豆瓣	链接: http://pan.baidu.com/s/1jGys69K 密码: gk6g这是其中一点，资料是我自己整理的，或是自己在网上买的，不喜勿喷，不要浪费我辛苦的资料。 谢谢!!! 100人 喜欢 ...	\N	0	0	0	0	3	2014-05-06 00:00:00	\N
2728	2014-05-29 20:52:37.061817	http://www.douban.com/group/topic/52780888/	英语资料免费分享 - 豆瓣	来自: boris8080 2014-05-15 11:16:09. 1、新概念俄语链接: http://pan.baidu.com/s/1hq2zYuw 2、小学英语课堂教学视频链接: http://pan.baidu.com/s/1kvvFw 3、少儿 ...	\N	24	0	0	0	3	2014-05-15 00:00:00	com,pan,http,baidu,链接,英语,小组,新东方,登录,国际音标,times,2014,1ntiCZBr,19,16,15,11,原版
2962	2014-05-29 20:53:52.266068	http://www.douban.com/group/topic/52411914/	轻松说粤语【免费分享零基础粤语视频教程大全】！ - 豆瓣	这是我教程http://pan.baidu.com/s/1hqmRusO里面有很多的视频教程 喜欢的朋友留下你们的邮箱，到时候我会全部发你们的， 有捉急的朋友可以直接加我微信，我 ...	\N	0	0	0	0	3	2014-05-06 00:00:00	\N
2965	2014-05-29 20:53:52.291083	http://www.douban.com/group/topic/52426432/	免费送上千本穿越小说啦。。。豆豆们赶紧来抢吧，... - 豆瓣	明白没，意思就是想要书的就和我交个朋友！） 还说什么呢？ 速度来吧！ http://pan.baidu.com/s/1o67DJAU 下载视频需要密码，喜欢的豆豆们加我徽信qinshan8100 ...	\N	0	0	0	0	3	2014-05-07 00:00:00	\N
2967	2014-05-29 20:53:52.307806	http://www.douban.com/group/topic/52328485/	平面设计学习资料免费下载 - 豆瓣	想要的朋友加我微信zyy0200，加的时候麻烦备资料密码，因为不想加到一些陌生人。全部分享在朋友圈里面咯。 速度来哦··· 链接: http://pan.baidu.com/s/1jGxC8L4.	\N	0	0	0	0	3	2014-05-05 00:00:00	\N
2970	2014-05-29 20:53:52.332795	http://www.douban.com/group/topic/52486378/	《牛尔的美白书全集》，想要的MM去下载吧！ - 豆瓣	下载地址：http://pan.baidu.com/s/1ntDfgNZ 解压码徽信qinshan8100 获取。备注解压码 这么好的分享，帖子沉了挺可惜的，为了让更多的MM能看到，喜欢就顺便顶 ...	\N	0	0	0	0	3	2014-05-08 00:00:00	\N
2968	2014-05-29 20:53:52.316126	http://www.douban.com/group/topic/52647866/	高评分小说免费分享·· - 豆瓣	来自: 天一斧 2014-05-12 14:26:01. 需要的朋友可以加我微信zyy0200 链接: http://pan.baidu.com/s/1hqDqebi 本优秀Kindle经典免费中文电子书. 喜欢 · 回应 推荐 ...	\N	1	0	0	0	3	2014-05-12 00:00:00	05,2014,删除,朱求,16,18,17,14,楼主,19,15,13,12,21,26,22,24,23,20
2966	2014-05-29 20:53:52.299419	http://www.douban.com/group/topic/52166583/	Unrepentant 泄5首【CD音质】 - 豆瓣	http://pan.baidu.com/s/1bncRXgz 不用谢~ Alanis也快点出碟吧。 Unrepentant各豪华版加歌： Deluxe Edition bonus track 15. "Forest of Glass" 5:08 iTunes edition ...	\N	1	0	0	0	3	2014-05-01 00:00:00	quot,2014,05,小组,frank1127,Unrepentant,02,01,删除,好治,喜歡,selkie,invisible,boy,15,&#,登录,海馬
2963	2014-05-29 20:53:52.274432	http://www.douban.com/group/topic/52301208/	46岁韩国最美辣妈，3个月瘦身20kg，13年从未反弹！ - 豆瓣	《塑身女王教你打造完美曲线》链接：http://pan.baidu.com/s/1kTlzq9x 复制在到浏览器下载哦，下载不了可以给我豆邮，我发给你，下载了下面回一句哦 被誉为“韩国最 ...	\N	1	0	0	0	3	2014-05-04 00:00:00	05,2014,删除,谢谢,楼主,20,16,分享,13,22,10,12,21,15,11,23,18,14,17
2955	2014-05-29 20:53:52.207736	http://www.douban.com/group/topic/52410489/	许哲佩圆舞曲全碟320k mp3 - 豆瓣	09. 转圈圈 10. 我数到三 11. 大提琴梦游- Interlude 12. 催眠[推荐] 13. 时间博物馆 14. My Dear - Acoustic Version 链接: http://pan.baidu.com/s/1bn3qA1x 密码: os61.	\N	1	0	0	0	3	2014-05-07 00:00:00	可乐,小组,全碟,2014,05,专辑,com,MP3,320K,登录,许哲佩,times,mp3,Interlude,320k,11,10,07
2957	2014-05-29 20:53:52.224426	http://www.douban.com/group/topic/52215006/	【资源】结构素描几何体范本 - 豆瓣	来自: franceyang 2014-05-02 19:46:19. 自己买的书，手机照片但愿像素不算太渣~. 基本的几何体算是都有了. 百度网盘整本分享 http://pan.baidu.com/s/1qW8V5Ju	\N	1	0	0	0	3	2014-05-02 00:00:00	2014,几何体,05,小组,franceyang,素描,书照,19,04,登录,删除,范本,照片,软体动物,两张,高校,times,com
2961	2014-05-29 20:53:52.257778	http://www.douban.com/group/topic/52519613/	知乎上超过1千赞的帖子.txt - 豆瓣	来自: 华年 2014-05-09 12:15:56. http://pan.baidu.com/share/link?shareid=504935842&uk=2754505399 请叫我雷锋.我的设备群78130968. 1人 喜欢 喜欢.	\N	1	0	0	0	3	2014-05-09 00:00:00	2014,05,删除,10,09,42,小组,收藏夹,华年,kindle,20,13,12,11,登录,知乎,千赞,txt
2958	2014-05-29 20:53:52.232762	http://site.douban.com/227712/widget/notes/15475871/note/352032995/	第二季二次元人体自学活动（第二课面部和头发） - 豆瓣	下载链接 http://pan.baidu.com/s/1jGsT8Ei 小站网盘被河蟹...尼玛... 有人完成任务了~值得夸奖！么么哒！ 分享到. 推荐 1人. 2人 喜欢 喜欢 · > 我来回应 ...	\N	1	0	0	0	3	2014-05-19 00:00:00	自学,人体,二次元,第二季,第二课,javascript,gt,com,2014,...,书房,浏览器,教程,触手,活动,面部,头发,尼玛,第一课
2964	2014-05-29 20:53:52.282735	http://www.douban.com/group/topic/52561852/	各类小说免费打包送豆豆们咯。 - 豆瓣	需要的朋友可以去我的朋友圈下载我的薇信zyy0200（不注明的不加不想收到陌生人的骚扰） 链接: http://pan.baidu.com/s/1c0zk5Vi 如果觉得可以的话，下载的朋友们 ...	\N	1	0	0	0	3	2014-05-10 00:00:00	2014,05,删除,19,14,16,20,13,12,楼主,21,18,15,22,11,58,26,24,谢谢
2986	2014-05-29 20:53:52.466192	http://www.douban.com/event/20887988/	亲子教育网络读书会：《PET父母效能训练》_豆瓣	电子书：http://pan.baidu.com/s/1sjNePVf 【报名方式】 1）将名字、参加日期、手机号、微博名发至微信li4017602，加好友时请注明“读书”） 2）将名字、参加日期、手机号、 ...	\N	1	0	0	0	3	2014-05-01 00:00:00	父母,效能,孩子,训练,亲子,middot,感兴趣,贴心,活动,手册,培训,参加,读书,教程,微博,YY,PET,冲突
2833	2014-05-29 20:53:19.360407	http://www.douban.com/group/topic/52680344/	【转推推贴】我是苦逼夹子君发的赵奕然减肥视频 - 豆瓣	链接：http://pan.baidu.com/share/link?shareid=2819512188&uk=4263690679 密码：r4ey 视频所含内容较多，体积较大，为了方便，亲们没 从推推搬帖子就从今天 ...	\N	2	0	0	0	3	2014-05-13 00:00:00	推推,赵奕然,九宫格,小组,减肥,夹子,视频,com,2014,登录,小红仔,君发,uk,times,shareid,share,pan,link
2973	2014-05-29 20:53:52.357809	http://www.douban.com/group/topic/52736327/	恋爱心理学终极来袭。 - 豆瓣	来自: 深海淘沙 2014-05-14 13:14:11. http://pan.baidu.com/s/1mgDhX5A 恋爱心理学 需要的朋友可以去我的朋友圈742715260. 1人 喜欢 喜欢 · 回应 推荐 喜欢 只看 ...	\N	0	0	0	0	3	2014-05-14 00:00:00	\N
2978	2014-05-29 20:53:52.39955	http://www.douban.com/group/topic/52518445/	精品300本清晰彩绘英文原版绘本，免费分享。 - 豆瓣	来自: 潘恩纳斯 2014-05-09 11:46:40. 链接: http://pan.baidu.com/s/1qWjTwsO 300本清晰英文原版绘本. 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	0	0	0	0	3	2014-05-09 00:00:00	\N
2979	2014-05-29 20:53:52.407863	http://www.douban.com/group/topic/52375321/	影教程PPT文件，喜欢的朋友过来围观···· - 豆瓣	这是地址链接， : http://pan.baidu.com/s/1mgkbw3e 要的朋友可以加我的微信zyy0200，加的时候要注明，摄影素材密码啊。 2人 喜欢 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	0	0	0	0	3	2014-05-06 00:00:00	\N
2730	2014-05-29 20:52:37.078508	http://www.douban.com/group/topic/52421280/	【免费分享】，不用感谢我，请叫我雷锋。(*^__^*) - 豆瓣	新东方8天8000词汇魔鬼训练营内部材料链接:http://pan.baidu.com/s/1pJkAfOZ 张国荣资料大全链接:http://pan.baidu.com/s/1c0273Mw 群星珍藏合集，有了它再也不 ...	\N	28	0	0	0	3	2014-05-07 00:00:00	pan,com,http,baidu,05,2014,链接,删除,19,下载,楼主,52,20,17,分享,回贴,12,09
2981	2014-05-29 20:53:52.424538	http://www.douban.com/group/topic/52443036/	1000本穿越小说合集，小伙伴们速度来打包.. - 豆瓣	需要的朋友可以去我的朋友圈下载我的薇信zyy0200（不注明的不加不想收到陌生人的骚扰） 链接: http://pan.baidu.com/s/1c0zk5Vi 如果觉得可以的话，下载的朋友们 ...	\N	0	0	0	0	3	2014-05-07 00:00:00	\N
2984	2014-05-29 20:53:52.449525	http://www.douban.com/group/topic/52637195/	分享电子书，无需邮箱，自行下载。 - 豆瓣	手有余香=========== 海量电子书，下到手软。 如果觉得对您有帮助请帮忙顶下帖子，不要让帖子沉了。谢谢了！！！ http://pan.baidu.com/s/1kTwoAcZ链接地址.	\N	0	0	0	0	3	2014-05-12 00:00:00	\N
2983	2014-05-29 20:53:52.441485	http://www.douban.com/group/topic/52929946/	分享酒店70美元优惠券信息，驴友们可能用得到~ - 豆瓣	或者豌豆荚等软件市场都能下载,也可用我的百度下载http://pan.baidu.com/s/1bn4Dj3L） 第2步.APP安装简单注册之后，点击“现金折价”里的兑换现金券； 第3步.	\N	1	0	0	0	3	2014-05-18 00:00:00	com,#####,小组,http,70,分享,输入,2014,05,登录,得到,美元,注册,大麦,折扣,驴友们,订房网,订房
2980	2014-05-29 20:53:52.416205	http://www.douban.com/group/topic/52421283/	送了电子书，又可以交朋友。 - 豆瓣	需要的朋友可以去我的朋友圈下载我的薇信zyy0200（不注明的不加不想收到陌生人的骚扰） 链接: http://pan.baidu.com/s/1bnktFdl 如果觉得可以的话，下载的朋友们 ...	\N	1	0	0	0	3	2014-05-07 00:00:00	05,2014,删除,16,14,18,17,15,12,臭蛋,22,13,23,10,德行,21,19,11,楼主
2977	2014-05-29 20:53:52.391157	http://www.douban.com/group/topic/52542246/	腾讯书院的讲座四个另求其他讲座下载方法 - 豆瓣	难得聪明 2014-05-10 12:34:58. http://pan.baidu.com/s/1mgkbBbq 张鸣：帝制并不那么容易被告别.mp3. 删除. 赞 回应. 你的回应. 回应请先登录 , 或注册. 推荐到广播.	\N	1	0	0	0	3	2014-05-09 00:00:00	讲座,小组,http,com,2014,登录,下载,怪奇,张鸣,另求,times,05,注册,居士,腾讯,录音,书院,方法
2975	2014-05-29 20:53:52.374486	http://www.douban.com/group/topic/52670674/	【分享】理财7年稳步增长，分享有用的理财资料	下载地址：http://pan.baidu.com/s/1sjFEjz3 提取密码：v3ms 另外推荐大家去个q群372556108，这个群是我刚开始是理财小白的时候，一位好哥们介绍我去的，里面的 ...	\N	1	0	0	0	3	2014-05-12 00:00:00	理财,2014,05,分享,小组,收益,13,理财产品,余额,Marina,5.8,0.0,资料,数数,登录,帖子
2976	2014-05-29 20:53:52.382815	http://www.douban.com/group/topic/52568297/	收集的手绘教程资料，送了 - 豆瓣	收集的手绘教程资料，送了. 不完美的女人. 来自: 不完美的女人 2014-05-10 15:15:44. http://pan.baidu.com/s/1sjrrOlf链接. 2人 喜欢 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	1	0	0	0	3	2014-05-10 00:00:00	2014,05,删除,搏击,23,12,16,17,19,13,22,成都,18,14,楼主,21,20,15,微信
2985	2014-05-29 20:53:52.457876	http://www.douban.com/group/topic/52638744/	好消息：【免费赠送kindle畅销书】 - 豆瓣	因为图片太大了！很多书都没有截图下来。 如果下面的图片没有显示的话，可以直接去我的微信haimei020 朋友圈去下载. http://pan.baidu.com/s/1hqKbtx6链接地址	\N	1	0	0	0	3	2014-05-12 00:00:00	2014,05,12,&#,小组,34,kindle,登录,畅销书,删除,喜欢,赠送,好消息,times,com,20,16,11
2982	2014-05-29 20:53:52.432854	http://www.douban.com/group/topic/53075476/	【 为了隐形の小腹肌！加油！】BR 90天记录贴 - 豆瓣	视频下载：http://pan.baidu.com/s/1kTG8jfL 课表： 共分三个阶段 workout 1-4 + cardio1 第一阶段一共四周 workout 5-8 + cardio2 第二阶段一共四周 workout 9-12 + ...	\N	1	0	0	0	3	2014-05-22 00:00:00	05,2014,22,删除,感觉,一点点,加油,腹肌,2014.5,肚子,09,...,运动,每天,26,16,15,今天
2779	2014-05-29 20:52:37.512056	http://www.douban.com/group/topic/52344482/	2014年Kindle资源网站分享 - 豆瓣	【kindle词典】http://pan.baidu.com/share/link?shareid=200915&uk=1628597749 【22本原生词典】http://www.douban.com/note/229359161/ 【6寸pdf资源】 ...	\N	6	0	0	0	3	2014-05-05 00:00:00	http,2014,05,com,www,删除,下载,06,kindle,格式,mobi,网站,共享,pdf,epub
2821	2014-05-29 20:53:19.260433	http://www.douban.com/group/topic/52267661/	送书。。。。。。。。。28G - 豆瓣	【加我回复：交朋友，一定要回复哦！】 书在百度网盘里，想要的豆子请点击链接:在下面！ 我的微信： zyy0200 地址：密码在我朋友全动态哦！ //pan .baidu .com/s / 1o6 ...	\N	0	0	0	0	3	2014-05-04 00:00:00	\N
2822	2014-05-29 20:53:19.268683	http://www.douban.com/group/topic/52637806/	英语短篇小说精品和英文小说原著 - 豆瓣	链接: http://pan.baidu.com/s/1sjvw9OT 英语短篇小说精品 链接: http://pan.baidu.com/s/1gdeLYV5 英文小说原著 需要的朋友可以加我的微信zyy0200. 10人 喜欢 ...	\N	0	0	0	0	3	2014-05-12 00:00:00	\N
2737	2014-05-29 20:52:37.136883	http://www.douban.com/group/topic/52368359/	刚刚在淘宝买的减肥电子书，分享给大家 - 豆瓣	刚刚在淘宝买的减肥电子书，分享给大家，喜欢就下载吧，你的回复是对我最大的鼓励 图解-2014最快速有效减肥方法 http://pan.baidu.com/s/1kT3GqmN	\N	11	0	0	0	3	2014-05-06 00:00:00	com,pan,http,baidu,珍藏版,减肥,电子书,精品,系列,小组,瘦脸,2014,登录,淘宝,times,Gem,Cat,...,喜欢
2761	2014-05-29 20:52:37.336968	http://www.douban.com/group/topic/52389569/	有关陈独秀，瞿秋白的讲座视频资料下载 - 豆瓣	讲座： 陈独秀和瞿秋白深化研究举例（国家图书馆讲座） 讲者：陈铁健 下载地址：http://pan.baidu.com/s/1hqsraXQ 从书生到领袖-瞿秋白（国家图书馆讲座） 讲者：陈铁健	\N	3	0	0	0	3	2014-05-06 00:00:00	com,http,讲座,下载,陈独秀,小组,dl,瞿秋白,陈铁健,怪奇,vmall,pan,baidu,登录,视频,居士,times,2014,地址
2785	2014-05-29 20:52:37.561926	http://www.douban.com/group/topic/52386278/	推荐几本关于柬埔寨吴哥窟的书·附下载链接 - 豆瓣	http://pan.baidu.com/s/1jGjz6Jk 《Lonely Planet:柬埔寨(2013年全新版)》 孤独星球的书没得说了，但是图比较少。在景点碰到一对美国加州的老夫妇，拿的就是这本。	\N	3	0	0	0	3	2014-05-06 00:00:00	http,吴哥,吴哥窟,吳哥,youku,id,html,beta,5274491,com,2014,柬埔寨,小组,介绍,景点,旅行
2731	2014-05-29 20:52:37.086848	http://www.douban.com/group/topic/52841303/	中华东奥会计网校课件下载，视频下载，雷锋贴别谢... - 豆瓣	东奥经济法基础全部课后试卷http://pan.baidu.com/s/1pJyfGsr 中华无纸化考试 ... 东奥刘忠十小时突破班视频http://pan.baidu.com/s/1qWFE6V6 2013全国无纸化 ...	\N	27	0	0	0	3	2014-05-16 00:00:00	http,com,baidu,pan,amp,会计,uk,shareid,share,link,7379,354348,网校,东奥,2014,...,下载,郭守杰,常月
2829	2014-05-29 20:53:19.327032	http://www.douban.com/thing/96/?on=1085065	时间管理 - 豆瓣	个人提升：http://pan.baidu.com/s/1pJi9ogV 目录截图A 目录截图B 同时也分享了一些别的笔记。 http://www.douban.com/note/348754358/ ...	\N	0	0	0	0	3	2014-05-26 20:53:19.183997	\N
2825	2014-05-29 20:53:19.293691	http://movie.douban.com/subject/1448724/comments?sort=time	藏尸楼短评 - 豆瓣电影	只能呵呵呵了. 0 有用 michiko 2014-01-29. 中谷美纪穿连衣裙怎么能这么好看. 0 有用 eien99 2014-01-27. http://pan.baidu.com/s/1hqmiLTE. 0 有用 ∞ 2013-12-05.	\N	0	0	0	0	3	2014-05-12 00:00:00	2013,2014,07,06,02,01,尸楼,08,04,短评,恐怖,恐怖片,剧情,电影,丰川悦司,中谷,黑泽清,美纪
2826	2014-05-29 20:53:19.302016	http://www.douban.com/group/topic/53189772/	Manon Meurt - Manon Meurt (2014) - 豆瓣	fabiano 2014-05-24 23:57:47. pan.baidu.com/s/1sjtvHm9. 删除. 赞 回应. 你的回应. 回应请先登录 , 或注册. 推荐到广播. This is Just A Modern Rock Song. 1178 人 ...	\N	0	0	0	0	3	2014-05-24 20:53:19.182504	fabiano,2014,小组,com,Meurt,Manon,&#,登录,times,douban,Just,34,24,23,05,注册,喜欢,话题
2827	2014-05-29 20:53:19.310359	http://site.douban.com/121012/room/803404/	资讯,角色,文章,漫画下载(SLOMObsessive的小站) - 豆瓣	... 曼哈顿博士1-4（附解读） 摩洛克1-2（第二期附解读） 百元大钞1册全另将绯红海盗单独整理出了一个文件夹，方便观看下载地址：http://pan.baidu.com/share/link?sh.	\N	0	0	0	0	3	2014-05-27 20:53:19.183006	lt,gt,喜欢,http,分享,剧透,DOFP,com,Sabah,Nur,En,......,战警,2014,2012,下载,xunlei,kuai,20,05
2823	2014-05-29 20:53:19.277016	http://site.douban.com/clown/	马戏团小丑的小站（豆瓣音乐人）	《猫的晚餐》 百度云下载地址：http://pan.baidu.com/s/1o6Fces6 一群热心制作人们提供的原创BEAT(提供下载） HipHop`school: http://site.douban.com/hiphopschool/ ...	\N	1	0	0	0	3	2014-05-26 20:53:19.180992	&#,59407,59402,59400,59394,59393,05,播放,音乐,小丑,com,13,马戏团,下载,http,26,关注,小站,Remix
2819	2014-05-29 20:53:19.243854	http://www.douban.com/group/topic/52801787/	King of Luxembourg - "Sir" / Royal Bastard (1989) - 豆瓣	fabiano 2014-05-15 20:01:02. pan.baidu.com/s/1qWmB84W. 删除. 赞 回应 · kozelek 2014-05-25 23:02:14. 顶两张分别入手黑胶. 删除. 赞 回应. 你的回应. 回应请先 ...	\N	0	0	0	0	3	2014-05-15 00:00:00	quot,&#,fabiano,King,34,小组,Sir,Royal,Luxembourg,Bastard,2014,pop,com,Turner,Alway,1989
3000	2014-05-29 20:53:52.616427	http://www.douban.com/group/topic/53052610/	英语六级美文70篇要的来下吧！	来自: 你是我的眼 2014-05-21 16:33:42. http://pan.baidu.com/s/1dDy39S1 要的自己下吧. 1人 喜欢 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	1	0	0	0	3	2014-05-21 00:00:00	小组,2014,05,...,登录,英语六级,times,com,70,资料,美文,英语专业,注册,喜欢,删除,话题,韩语,手机
2824	2014-05-29 20:53:19.285536	http://www.douban.com/group/topic/52648758/	摄影PPT基本教程· - 豆瓣	链接: http://pan.baidu.com/s/1hqKHzEG 摄影基础课件教程 链接: http://pan.baidu.com/s/1kTA1VO7 摄影用光基础 需要的朋友加我zyy0200. 喜欢 · 回应 推荐 喜欢 只 ...	\N	2	0	0	0	3	2014-05-12 00:00:00	05,2014,删除,14,舞二林,16,19,12,17,18,26,21,15,楼主,24,13,23,22,20
2837	2014-05-29 20:53:19.393733	http://www.douban.com/group/topic/52369215/	摄影教程PPT文件，分享给各位， - 豆瓣	4希望自己熟练使用PS软件精确调色、修片，饰润，把摄影照片化腐朽为神奇的摄友。快点看过来哦··· 这是地址链接， : http://pan,baidu.com/s/1mgkbw3e 要的朋友 ...	\N	0	0	0	0	3	2014-05-06 00:00:00	\N
2838	2014-05-29 20:53:19.40206	http://www.douban.com/group/topic/52368898/	轻音乐上千首，整理好了，有图有真相。 - 豆瓣	... 朋友圈下载我的薇信zyy0200（不注明的不加不想收到陌生人的骚扰） 还有很多的学习素材哈，与你们分享，结交更多的朋友。 链接: http://pan,baidu.com/s/1kTLriR1.	\N	0	0	0	0	3	2014-05-06 00:00:00	\N
2849	2014-05-29 20:53:19.493767	http://www.douban.com/group/topic/52517695/	喜欢看书的友友们，免费赠送，速围观、 - 豆瓣	来自: 大圈子啊 2014-05-09 11:29:48. 链接: http://pan.baidu.com/s/1bn7ux7T穿越小说合集 链接: http://pan.baidu.com/s/1pJuKHXh 玄幻小说. 喜欢 · 回应 推荐 喜欢 ...	\N	0	0	0	0	3	2014-05-09 00:00:00	\N
2850	2014-05-29 20:53:19.502097	http://www.douban.com/group/topic/52557880/	英语原版小说和英语短篇精品小说，要的请过来。 - 豆瓣	链接: http://pan.baidu.com/s/1sjvw9OT 英语短篇小说精品 链接: http://pan.baidu.com/s/1gdeLYV5 英文小说原著 需要的朋友可以加我微信zyy0200. 1人 喜欢 喜欢.	\N	0	0	0	0	3	2014-05-10 00:00:00	\N
2851	2014-05-29 20:53:19.510476	http://www.douban.com/group/topic/52558388/	英语原版小说和英语短篇精品小说，要的请过来。 - 豆瓣	链接: http://pan.baidu.com/s/1sjvw9OT 英语短篇小说精品 链接: http://pan.baidu.com/s/1gdeLYV5 英文小说原著 需要的朋友可以加我微信zyy0200. 喜欢 · 回应 推荐 ...	\N	0	0	0	0	3	2014-05-10 00:00:00	\N
2854	2014-05-29 20:53:19.535478	http://www.douban.com/group/topic/53008876/	免越狱PW1/PW2 字体替换方法（可自定义自己喜欢的... - 豆瓣	所需的组件下载地址：pan.baidu.com/s/1hqsrIfy （如果分享链接失效，请点击只看楼主，获取最新地址） 在分享地址中，你需要下载三个文件，分别是：fonts.tar.gz ...	\N	0	0	0	0	3	2014-05-20 00:00:00	字体,自定义,根目录,替换,安装,更新,pda,fonts,Kindle,小组,hi,com,amp,...,文件,越狱,喜欢,宋体,地址
2844	2014-05-29 20:53:19.452091	http://9.douban.com/subject/9451833/	道兰[NHK纪录片] (九点) - 豆瓣	下载地址：链接:http://pan.baidu.com/s/1o6mF9oA 提取密码:rzja 1.《BBC：猥琐大不列颠》BBC: Rude Britannia【全三集】 2.《历史频道：诸神之战》(History ...	\N	0	0	0	0	3	2014-05-15 00:00:00	NHK,2014,...,纪录片,原文,网盘,05,查看,http,com,04,道兰,推荐,注销,合集,博客,字幕组,nbsp,amp,BBC
2839	2014-05-29 20:53:19.410447	http://movie.douban.com/subject/4133279/	元禄忠臣藏后篇(豆瓣) - 豆瓣电影	0 有用 eien99 2014-03-10. http://pan.baidu.com/s/1i3JXCXn. > 更多短评8条. 0 有用 王杀 2014-04-15. 早前看过忘标，今又草草重撸一遍。 0 有用 空思 2014-03-30.	\N	0	0	0	0	3	2014-05-06 00:00:00	禄忠臣,2014,电影,后篇,03,短评,沟口,健二,gt,1942,11,旬报,影评,这部,看过,日本,武士
2834	2014-05-29 20:53:19.368726	http://www.douban.com/group/topic/52374844/	喜欢看欧美电影的童鞋，速度过来围观啊· - 豆瓣	需要的朋友可以去我的朋友圈下载我的薇信zyy0200（不注明的不加不想收到陌生人的骚扰） 链接: http://pan。baidu。com/s/1i3hzF1r. 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	0	0	0	0	3	2014-05-06 00:00:00	电影,小组,...,登录,童鞋,times,com,2014,喜欢,注册,围观,欧美,话题,朋友圈,手机,少男,谴之雷,行摄
2847	2014-05-29 20:53:19.4771	http://www.douban.com/group/topic/52244701/	S10E22片尾的like a virgin戳中泪点了 - 豆瓣	Amos Lee - Like a Virgin 剧里面版本 下载版本http://pan.baidu.com/s/1qWK0RXM 56在线版本http://www.56.com/u88/v_MTEzMjQ5MTI1.html. 删除. 赞 回应 ...	\N	1	0	0	0	3	2014-05-03 00:00:00	05,2014,删除,03,com,片尾,http,GT,56,小组,amos,07,...,版本,首歌,编曲,男声版,youku
2840	2014-05-29 20:53:19.418734	http://www.douban.com/group/topic/52118473/	耽美被查，美剧下架，韩娱停播 - 豆瓣	... 网站就上哪个，比那群港灿还要自由自在，不要担心浏览器被黑，已经出到第7代，黑一代出一代，谢谢！ 翻长城神器http://pan.baidu.com/s/1BzbWE 提取码： 5rmx .	\N	1	0	0	0	3	2014-04-30 00:00:00	04,30,2014,删除,10,美剧,群港灿,vicky,shining,11,下架,下载,在线看,人人,人想,YOUTUBE,更新,com
2836	2014-05-29 20:53:19.385397	http://site.douban.com/119902/room/973961/	景观设计/城市规划(我爱建筑的小站) - 豆瓣	Michael Jantzen 设计，位于美国。项目多个八英尺直径的圆环组合而成，可作为雕塑摆放于公园中。 下载：http://dl.vmall.com/c04o3k28by 或http://pan.baidu.com/s/ ...	\N	0	0	0	0	3	2014-05-16 00:00:00	com,http,2014,05,城市规划,建筑,景观设计,喜欢,分享,设计,关注,小站,vmall,pan,dl,baidu,22,16,09
2841	2014-05-29 20:53:19.427239	http://www.douban.com/group/topic/53252017/	装饰公司起名_装饰公司起名字大全	公司取名大师软件注册版免费下载：http://pan.baidu.com/s/1xPEqy 注册码获取地址：http://item.taobao.com/item.htm?id=14207010789 公司就像一个大家庭，你家的 ...	\N	1	0	0	0	3	2014-05-26 20:53:19.19	装饰,公司,名字,http,起名,取名,小组,注册版,item,com,LOW,2014,大全,软件,注册,佛主,26,05
2848	2014-05-29 20:53:19.48543	http://www.douban.com/group/topic/52529493/	整理书单 - 豆瓣	... 2014-05-12 13:35:30. 给我发一个，想看看。 给我发一个，想看看。 ZXCD · http://pan.baidu.com/share/link?shareid=1422353717&uk=3426659273&third=15.	\N	2	0	0	0	3	2014-05-09 00:00:00	2014,05,蜀黍,30,书单,小组,amp,删除,找全,com,11,发信,给我发,登录,幸福,一个多,舍费尔,开心
2857	2014-05-29 20:53:19.56071	http://www.douban.com/group/topic/52693283/	冰与火之歌，终于找到中英文版了，要的赶紧来拿啊。 - 豆瓣	喜欢的豆油赶紧来拿啊 http://pan.baidu.com/s/1pJ8sdkv · http://pan.baidu.com/s/1qWCtN6O 加我威信qinshan8100 备注以书会友提取码都分享在我的盆友圈了.	\N	0	0	0	0	3	2014-05-13 00:00:00	\N
2858	2014-05-29 20:53:19.569024	http://www.douban.com/group/topic/52517096/	喜欢看书的友友们，免费赠送，速围观、 - 豆瓣	来自: 大圈子啊 2014-05-09 11:17:32. 链接: http://pan.baidu.com/s/1bn7ux7T穿越小说合集 链接: http://pan.baidu.com/s/1pJuKHXh 玄幻小说. 喜欢 · 回应 推荐 喜欢 ...	\N	0	0	0	0	3	2014-05-09 00:00:00	\N
2859	2014-05-29 20:53:19.577371	http://www.douban.com/group/topic/52516923/	喜欢看书的友友们，免费赠送，速围观、 - 豆瓣	来自: 大圈子啊 2014-05-09 11:13:51. 链接: http://pan.baidu.com/s/1bn7ux7T穿越小说合集 链接: http://pan.baidu.com/s/1pJuKHXh 玄幻小说. 喜欢 · 回应 推荐 喜欢 ...	\N	0	0	0	0	3	2014-05-09 00:00:00	\N
2860	2014-05-29 20:53:19.585735	http://www.douban.com/group/topic/52558268/	英语原版小说和英语短篇精品小说，速取 - 豆瓣	链接: http://pan.baidu.com/s/1sjvw9OT 英语短篇小说精品 链接: http://pan.baidu.com/s/1gdeLYV5 英文小说原著 需要的朋友可以加我微信zyy0200. 喜欢 · 回应 推荐 ...	\N	0	0	0	0	3	2014-05-10 00:00:00	\N
2862	2014-05-29 20:53:19.602694	http://www.douban.com/group/topic/52530840/	各类电子书小说打包分享中····· - 豆瓣	来自: 元若真 2014-05-09 16:17:21. 链接: http://pan.baidu.com/s/1bn7ux7T 链接: http://pan.baidu.com/s/1pJuKHXh · 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	0	0	0	0	3	2014-05-09 00:00:00	\N
2863	2014-05-29 20:53:19.610762	http://www.douban.com/group/topic/52520637/	各类电子书免费分享，豆豆们来拿哦。 - 豆瓣	来自: 我飞天梦 2014-05-09 12:47:11. 链接: http://pan.baidu.com/s/1bn7ux7T 链接: http://pan.baidu.com/s/1pJuKHXh · 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	0	0	0	0	3	2014-05-09 00:00:00	\N
2864	2014-05-29 20:53:19.619076	http://www.douban.com/group/topic/52528345/	各类电子书籍打包免费分享中··· - 豆瓣	来自: 摩托大王 2014-05-09 15:23:32. 链接: http://pan.baidu.com/s/1bn7ux7T 穿越小说合集 链接: http://pan.baidu.com/s/1pJuKHXh 密码: 喜欢 · 回应 推荐 喜欢 只 ...	\N	0	0	0	0	3	2014-05-09 00:00:00	\N
2865	2014-05-29 20:53:19.62743	http://www.douban.com/group/topic/52637581/	英语短篇小说精品和英文小说原著 - 豆瓣	链接: http://pan.baidu.com/s/1sjvw9OT 英语短篇小说精品 链接: http://pan.baidu.com/s/1gdeLYV5 英文小说原著 需要的朋友可以加我的微信zyy0200. 喜欢.	\N	0	0	0	0	3	2014-05-12 00:00:00	\N
2866	2014-05-29 20:53:19.660781	http://www.douban.com/group/topic/52743949/	电视摄影和基础摄影 - 豆瓣	来自: 办公软件 2014-05-14 15:39:16. 链接: http://pan.baidu.com/s/1hqKbKbE 6gwo电视摄影教程 http://pan.baidu.com/s/1c006YSK 摄影基础教程 需要的朋友可以 ...	\N	0	0	0	0	3	2014-05-14 00:00:00	\N
2867	2014-05-29 20:53:19.669082	http://www.douban.com/group/topic/52528577/	各类电子小说打包分享中····· - 豆瓣	来自: 摩托大王 2014-05-09 15:28:39. 链接: http://pan.baidu.com/s/1bn7ux7T 链接: http://pan.baidu.com/s/1pJuKHXh · 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	0	0	0	0	3	2014-05-09 00:00:00	\N
2875	2014-05-29 20:53:19.735795	http://movie.douban.com/subject/25837574/questions/10165/	《男孩》 请问大家都是在哪里看的这个电影，能否分享一下链接 ...	《男孩》 请问大家都是在哪里看的这个电影，能否分享一下链接地址？ 答案：http://pan.baidu.com/share/link?shareid=2255992042&uk=587258832&app=zd...	\N	0	0	0	0	3	2014-05-11 00:00:00	\N
2877	2014-05-29 20:53:19.752477	http://www.douban.com/group/topic/53314215/	祛痘、减腿、化妆、祛斑，你有这方面的需要吗？	... 天性，小编特地收藏了祛痘、减退、化妆、祛斑的视频， 希望可以帮到大家，如果大家喜欢的话，可以来找我哦 祛斑、瘦腿、化妆视频 http://pan.baidu.com/s/1sj79nKL	\N	0	0	0	0	3	2014-05-28 20:53:19.207861	\N
2873	2014-05-29 20:53:19.719125	http://www.douban.com/thing/96/experience/?p=1&order=time	关于时间管理的故事 - 豆瓣	个人提升：http://pan.baidu.com/s/1pJi9ogV 目录截图A 目录截图B 同时也分享了一些别的笔记。 http://www.douban.com/note/348754358/ ...	\N	0	0	0	0	3	2014-05-14 00:00:00	30,00,时间,......,患者,回答,抑郁症,抑郁,喜欢,学习,碎片,减退,45,17,11,管理,事情,查看
2872	2014-05-29 20:53:19.710808	http://www.douban.com/group/topic/53155165/?type=rec	秦晖历史与现实中的土地问题	baidu真厉害，简直是秒删啊，我把文件名改成qh看好点不 秦晖历史与现实中的土地问题http://pan.baidu.com/s/1c0gUT2K · 1人 喜欢 喜欢 · 回应 推荐 喜欢. 还没人 ...	\N	1	0	0	0	3	2014-05-23 20:53:19.205374	秦晖,小组,现实,历史,讲座,土地,登录,怪奇,哲别,之箭,times,com,baidu,2014,话题,问题,居士,录音,喜欢
2869	2014-05-29 20:53:19.685749	http://www.douban.com/group/topic/52135783/	告诉大家一个屏蔽优酷视频等视频广告的软件 - 豆瓣	... 蛮好用的啊,就传到网盘去了,给大家共享一下,安装好就能屏蔽好多网站的广告哦,我都去试过了,呵呵. 网盘地址:http://pan.baidu.com/s/1i3uWCKl 希望大家能喜欢啊.	\N	1	0	0	0	3	2014-04-30 00:00:00	小组,视频,广告,陈奕迅,登录,屏蔽,网盘,优酷,times,com,2014,注册,喜欢,告诉,搜索,软件,话题
2868	2014-05-29 20:53:19.677437	http://www.douban.com/group/topic/52317964/	最齐全的吉他练习教程全·· - 豆瓣	http://pan.baidu.com/share/link?shareid=1931474365&uk=504273305 吉他换弦图文视频教程 http://www.douban.com/group/topic/47842759/ 吉他在冬季和夏季 ...	\N	1	0	0	0	3	2014-05-05 00:00:00	http,吉他,www,吉他谱,jitashe,et,com,artist,小组,html,douban,教程,各调,topic,tanjita,hexun,group,blog
2870	2014-05-29 20:53:19.694099	http://www.douban.com/group/topic/52626603/	【晒问题】我又半夜丧心病狂的粗线了，嘎嘎 - 豆瓣	蹦蹦+ (夏日摸摸腿) 2014-05-12 01:25:48. http://pan.baidu.com/share/link?shareid=4092918309&uk=2953729354&app=zd 请看. 删除. 赞 回应 ...	\N	1	0	0	0	3	2014-05-11 00:00:00	05,01,2014,12,删除,Mojito,...,地址,27,26,24,邀请,33,31,29,豆油,caoliu,35,32
2883	2014-05-29 20:53:19.802512	http://www.douban.com/group/topic/52404261/	我感觉李小璐完了~ - 豆瓣	白三爷 2014-05-06 23:57:10. http://pan.baidu.com/s/1qWtwHzA 看过请点赞. 删除 .... 寻找蝴蝶 2014-05-07 00:14:59. http://pan.baidu.com/s/1jGiJBcM 这个还在.	\N	0	0	0	0	3	2014-05-06 00:00:00	\N
2880	2014-05-29 20:53:19.777304	http://www.douban.com/group/topic/52792770/	考研数学解题思路——教你冲刺数学140+ - 豆瓣	... 与学习方法跟大家分享一下。需要的朋友直接点击链接网盘下载即可 http://pan.baidu.com/s/1kT9MvbD，更多考研资料专业课真题请到功课吧www.gongkeba.com.	\N	1	0	0	0	3	2014-05-15 00:00:00	考研,数学,小组,...,专业课,com,140,登录,times,2014,15,注册,解题,冲刺,功课,思路,话题
2891	2014-05-29 20:53:19.869254	http://www.douban.com/group/topic/52441152/	100本心理学书籍免费送啦。。。要的赶紧来抢吧。。... - 豆瓣	还说什么呢？ 速度来吧！ http://pan.baidu.com/s/1kTwoAcZ 视频需要网址，紧跟回帖就可以得到密码 想免费拿书就这么简单，加我徽信qinshan8100 备注以书会友.	\N	0	0	0	0	3	2014-05-07 00:00:00	\N
2892	2014-05-29 20:53:19.877424	http://www.douban.com/group/topic/52727174/	心理学初级之催眠入门教程。 - 豆瓣	来自: 若水蝴蝶 2014-05-14 09:55:24. 链接: http://pan.baidu.com/s/1mg9ekNA 催眠教程之入门教程需要的朋友可以去我的朋友圈742715260. 3人 喜欢 喜欢.	\N	0	0	0	0	3	2014-05-14 00:00:00	\N
2890	2014-05-29 20:53:19.860951	http://www.douban.com/group/topic/52518986/	精品300本清晰彩绘英文原版绘本，免费分享。 - 豆瓣	来自: 潘恩纳斯 2014-05-09 11:58:41. 链接: http://pan.baidu.com/s/1qWjTwsO 300本清晰英文原版绘本. 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	1	0	0	0	3	2014-05-09 00:00:00	05,2014,删除,16,18,14,19,22,15,23,17,13,21,楼主,11,中到大雨,微信,38,24
2896	2014-05-29 20:53:19.910951	http://www.douban.com/group/topic/52192016/	140501-SUPERVC-北京平谷乐谷音乐节-全媒体集锦 - 豆瓣	sorry 4 before 夜空多灿烂 北方的阳光 木偶剧 优雅 照片 http://www.douban.com/photos/album/130511018/ 音频（全程下载） http://pan.baidu.com/s/1pLqaE 视频	\N	1	0	0	0	3	2014-05-01 00:00:00	乐谷,140501,平谷,音乐节,http,com,果味,vc,小组,SUPERVC,Greenhat,1978,北京,集锦,youku,sorry,id
2885	2014-05-29 20:53:19.819186	http://book.douban.com/people/Q598176297/do	恶魔的奶爸在读的书(32) - 豆瓣读书	官方电子书下载：http://pan.baidu.com/s/1i3LrW37，有电影的剧情带入读这本应该会很容易，据说中国常州制的小红在小说了非常猛。官方的漫画至今未找到，哪位 ...	\N	0	0	0	0	3	2014-05-09 00:00:00	在读,有售,元起,2014,2013,middot,09,http,com,15,排序,梦入,奶爸,pan,baidu,USD,32,2008,07
2894	2014-05-29 20:53:19.894253	http://www.douban.com/group/topic/53090427/	【大龙凤音乐】免费分享ukulele教程和乐谱压缩包	百度云：http://pan.baidu.com/s/1c0jC992 大家来下载吧。 大龙凤音乐是谁? 我们是坐标在广州的一个音乐工作室。业务包括音乐文化推广和分享、乐评、乐器评测、 ...	\N	1	0	0	0	3	2014-05-22 00:00:00	ukulele,音乐,小组,龙凤,com,&#,登录,分享,指弹,压缩包,times,http,UKULELE,34,2014,...,注册,乐谱
2879	2014-05-29 20:53:19.769129	http://www.douban.com/group/topic/52180455/	大家说说自从净网之后都去哪里载电影 - 豆瓣	百度搜site:pan.baidu.com.cn[空格]电影名 删了不少资源但是也没删干净，希望 ... 咩，谢谢 咩咩，谢谢 碎蛋战斗机. 刚写错了，百度网盘地址是pan.baidu.com，没有cn.	\N	0	0	0	0	3	2014-05-01 00:00:00	05,2014,删除,02,01,21,03,碎蛋,电影,23,个控,球鞋,快播,百度网,瘦高,衬衣,格子,战斗机,22
2886	2014-05-29 20:53:19.827533	http://www.douban.com/group/topic/53202179/	首饰工厂诚招合作伙伴，外贸内销都可以 - 豆瓣	... 接触并了解，我愿意分享这个平台， 我们一起把蛋糕做大，同享丰盛！ ( 有完整的视频介绍,介绍公司以及如果开发市场,敬请观看http://pan.baidu.com/s/1pJJiiCF )	\N	1	0	0	0	3	2014-05-25 20:53:19.212322	首饰,小组,2014,公司,com,2009,05,创业,登录,诚招,合伙人,times,25,16,...,巴伦,注册,楼主
2884	2014-05-29 20:53:19.810866	http://www.douban.com/group/topic/52142250/	权利的游戏现在去哪里下载 - 豆瓣	宁貞子 2014-04-30 22:58:09. http://pan.baidu.com/share/link?shareid=4197817151&uk=624665533. 删除. 赞 回应 · 芥川真之介 2014-04-30 23:06:16. 人人没了 ...	\N	1	0	0	0	3	2014-04-30 00:00:00	2014,04,30,删除,05,22,人人,美剧,23,08,小组,16,注册,下载,影视,粗来,真之介,下辣
2888	2014-05-29 20:53:19.844345	http://www.douban.com/group/topic/52425311/	以前买的面包全套视频教程.吃货们速度来拿。 - 豆瓣	6-2 芝麻脆片的制作过程 6-3 金牛角面包的制作过程 想要的同学可以加我的WX：zyy0200.我已经分享到朋友圈了，朋友们去拿吧。。 链接: http://pan.baidu.com/s/ ...	\N	1	0	0	0	3	2014-05-07 00:00:00	05,2014,删除,17,16,11,22,15,12,14,13,面包,19,18,10,巴鲁,21,制作,08
2881	2014-05-29 20:53:19.785841	http://www.douban.com/group/topic/52610540/	【百度云盘】远离尘嚣Part 1（BBC 1998版） - 豆瓣	... 是像这98年版本中的样子，应该是独具粗旷和野性。 豆瓣条目：http://movie.douban.com/subject/1777668/ 百度云盘：part1— http://pan.baidu.com/s/1o62o4MQ.	\N	1	0	0	0	3	2014-05-11 00:00:00	小组,BBC,尘嚣,云盘,com,2014,1998,登录,远离,times,http,douban,Part,喜欢,注册,电影,托马斯
2878	2014-05-29 20:53:19.760813	http://www.douban.com/group/topic/53362240/	【分享】牛津通识读本（47本）（azw3格式）	认真研读的话，能收获不少。即便只是通读一遍，也能对很多自己原本不知道的学科（我是真的有不少在之前都不知道啊TAT）有所了解。 度盘：http://pan.baidu.com/s/ ...	\N	1	0	0	0	3	2014-05-29 13:53:19.208386	29,2014,05,删除,小组,47,14,分享,kindle,azw3,识读,登录,牛津,格式,易水寒,times,com,20
2893	2014-05-29 20:53:19.885945	http://www.douban.com/group/topic/52621839/	杨令侠《加拿大与美国政治体系比较》 - 豆瓣	为什么说加拿大诞生后的60多年内既没有独立也没有统一？这个历史上罢工风潮最严重的时候仅死亡过一个工人的国家的国民性如何？ 下载：http://pan.baidu.com/s/ ...	\N	1	0	0	0	3	2014-05-11 00:00:00	小组,杨令侠,怪奇,加拿大,登录,居士,讲座,times,com,2014,注册,美国,政治,录音,体系,比较,历史,话题
2902	2014-05-29 20:53:19.960964	http://www.douban.com/group/topic/52205511/	【楼主亲试】美容护肤美甲化妆瘦身瑜伽等... - 豆瓣	11 时尚美甲视频教程专业美甲教学教程大全指甲美容培训技术技法 我都传到网盘了，http://pan.baidu.com/s/1pJnrMht 需要的问我要密码，加我的微信号jhfc666 ...	\N	0	0	0	0	3	2014-05-02 00:00:00	\N
2899	2014-05-29 20:53:19.935921	http://www.douban.com/people/tanya3000/notes	T教授的日记 - 豆瓣	http://pan.baidu.com/share/link?shareid=3237705071&uk=3254847099 http://pan.baidu.com/share/link?shareid=3239100293&uk=3254847099 ...	\N	0	0	0	0	3	2014-05-13 00:00:00	middot,喜欢,13,05,......,2014,18,分享,推荐,31,com,amp,27,2013,20,19,16,06
2905	2014-05-29 20:53:19.985925	http://www.douban.com/group/topic/52476289/	一步一步学摄影视频教程，一共有128集，想要的豆友... - 豆瓣	光说不练假把式，又说又练真把式 豆友需要的，+我徽信qinshan8100 我慢慢会回复大家！ http://pan.baidu.com/s/1o67DJAU 豆友需要的，+我徽信qinshan8100 我 ...	\N	0	0	0	0	3	2014-05-08 00:00:00	\N
2908	2014-05-29 20:53:20.010994	http://www.douban.com/group/topic/52429678/	1000穿越小说合集，小伙伴们速度来打包.. - 豆瓣	需要的朋友可以去我的朋友圈下载我的薇信zyy0200（不注明的不加不想收到陌生人的骚扰） 链接: http://pan.baidu.com/s/1c0zk5Vi 如果觉得可以的话，下载的朋友们 ...	\N	1	0	0	0	3	2014-05-07 00:00:00	小组,2014,05,登录,下载,爱书,朋友圈,zyy0200,times,com,23,13,1000,07,...,..,分享,小伙伴
2917	2014-05-29 20:53:20.08604	http://www.douban.com/group/topic/52922565/	冰与火之歌1-5电子书欢迎下载哈 - 豆瓣	来自: 渭城一场雨 2014-05-18 20:30:00. 百度网盘 链接: http://pan.baidu.com/s/1GQzDG 密码: htr4 各位下载后好歹冒个泡吧. 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	1	0	0	0	3	2014-05-18 00:00:00	2014,05,19,删除,小组,火之歌,10,登录,马房,剧透,times,com,22,21,18,12,...,注册
2912	2014-05-29 20:53:20.044351	http://www.douban.com/group/topic/52433817/	进来选一张你喜欢的电影的明信片我寄给你 - 豆瓣	正在抽烟中 2014-05-07 17:33:45. 1000本穿越小说分享给豆油 链接: http://pan.baidu.com/s/1c0zk5Vi 密码: g1nf. 删除. 赞 回应 ...	\N	0	0	0	0	3	2014-05-07 00:00:00	\N
2914	2014-05-29 20:53:20.060992	http://www.douban.com/group/topic/52440126/	2014最全EXCEL资料大全 - 豆瓣	我的网盘：链接:http://pan.baidu.com/s/1pJFJx9p. ====提取码请加威信5963381 获取===== 加我时发送验证“excel” 索取密码提取 给大家带来的不便请谅解！	\N	0	0	0	0	3	2014-05-07 00:00:00	\N
2909	2014-05-29 20:53:20.019328	http://music.douban.com/review/6664498/	Matthew And The Atlas - Other Rivers（Indie Folk，Singer ...	Free Download: http://pan.baidu.com/s/1mg5arqS（320kbs） 原创授权内容禁止转载. 你认为这篇评论： 有用 没用. 分享到. 推荐 · > 我来回应. 本评论版权属于作者自 ...	\N	0	0	0	0	3	2014-05-10 00:00:00	quot,Rivers,Other,album,10,middot,Matthew,music,track,folk,Matt,Hegarty,Atlas,评论,自闭症
2987	2014-05-29 20:53:52.507925	http://www.douban.com/group/topic/52471779/	分享【零基础ps手绘速成视频教程】自己的言情女主角 - 豆瓣	... 张相片你也可以做言情女主角哦。有木有想要的呢？留言加豆油，分享给你哦. 这是链接地址这是地址链接， : http://pan.baidu.com/s/1mgkbw3e 加的时候请注明，.	\N	0	0	0	0	3	2014-05-08 00:00:00	\N
2913	2014-05-29 20:53:20.05264	http://www.douban.com/group/topic/52383493/	学摄影视频教程，喜欢的朋友过来围观吧。 - 豆瓣	豆友需要的，+我微信；zyy0200 我慢慢会分享在朋友圈给大家！ 链接: http://pan.baidu.com/s/1o67DJAU. 豆友需要的，+我微信；zyy0200 我慢慢会分享在朋友圈给 ...	\N	1	0	0	0	3	2014-05-06 00:00:00	小组,登录,分享,朋友圈,摄影,豆友,视频教程,微信,zyy0200,times,com,2014,15,...,喜欢,注册,围观,过来
2916	2014-05-29 20:53:20.0777	http://www.douban.com/group/topic/52484355/	英语原版小说，要的豆豆速来。 - 豆瓣	需要的朋友可以去我的朋友圈下载我的薇信zyy0200（不注明的不加不想收到陌生人的骚扰） http://pan.baidu.com/s/1qWArEsW 如果觉得可以的话， 下载的朋友们 ...	\N	1	0	0	0	3	2014-05-08 00:00:00	2014,05,删除,18,16,15,13,17,22,12,11,10,14,20,楼主,混求,张匪献忠,21,23
2907	2014-05-29 20:53:20.002587	http://www.douban.com/group/topic/52691529/	857本优秀Kindle经典免费中文电子书 - 豆瓣	来自: 流浪北方的风 2014-05-13 13:31:24. 链接: http://pan.baidu.com/s/1hqDqebi 857本优秀Kindle经典免费中文电子书. 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	1	0	0	0	3	2014-05-13 00:00:00	Kindle,2014,小组,13,05,码是,免费中文,857,14,登录,电子书,朋友圈,times,gt,com,742715260,59,10
2904	2014-05-29 20:53:19.977636	http://www.douban.com/group/topic/53186164/	《绿度母宝藏》pdf电子版结缘赠送	很喜欢的一本书，弄到了高清扫描pdf电子版。 想要结缘给大家。 留邮箱可以，到百度网盘里自己下载也可以。 http://pan.baidu.com/s/1kTkK2Qb 嗡哒咧嘟哒咧嘟咧 ...	\N	1	0	0	0	3	2014-05-24 20:53:19.221182	2014,05,com,删除,红袖添香,书读,qq,28,谢谢,小组,电子版,绿度母,pdf,24,结缘,发送,全素
2901	2014-05-29 20:53:19.952611	http://www.douban.com/group/topic/53092256/	3000本小说打包分享，免费送~~有图有真相！！！	优益C 2014-05-22 14:59:57. 想要的地址在这：链接链接: http://pan.baidu.com/s/1dD5VlbN提取码加我微信获取哈5963381. 删除. 赞 回应 ...	\N	1	0	0	0	3	2014-05-22 00:00:00	2014,05,22,删除,优益,楼主,com,17,15,豆油,07,14,小组,我要,24,16,谢谢,好书
2900	2014-05-29 20:53:19.944415	http://www.douban.com/group/topic/52106787/	【小组书库第一期】Lonely Planet 孤独星球旅行指... - 豆瓣	直接网盘下载，留邮箱什么的最讨厌了（还有收集邮箱卖给垃圾广告商之嫌） ================================= 传送门：http://pan.baidu.com/s/1hqBTBgg	\N	1	0	0	0	3	2014-04-29 00:00:00	小组,Planet,Lonely,2014,...,书库,登录,星球,第一期,孤独,背包客,网盘,times,com,49,05,旅行,喜欢
2898	2014-05-29 20:53:19.927616	http://www.douban.com/group/topic/52739207/	会摄影，不会修片，那咋成，我这里有教你处理相片的 - 豆瓣	... 或者给我给你地址，朋友们自己直接去下载， PS入门70节下载地址：http://pan.baidu.com/share/link?shareid=528282&uk=2769149121分批下载一节一节课下载.	\N	1	0	0	0	3	2014-05-14 00:00:00	05,2014,com,删除,qq,17,19,楼主,26,14,21,16,00,谢谢,18,13,09,12,惜缘
2911	2014-05-29 20:53:20.035971	http://www.douban.com/group/topic/52679380/	漫威MARVEL的2本有声书《Tomorrow Men》《Against ... - 豆瓣	http://pan.baidu.com/s/1kTLX1x9 另外还有小伙伴传过内战civil war也扔这了，就当做个广告 http://stonyshipping.lofter.com/post/255a49_11b7240 · 喜欢 · 回应 推荐 ...	\N	1	0	0	0	3	2014-05-13 00:00:00	有声书,2014,小组,漫威,Tomorrow,Men,05,...,com,MARVEL,Against,17,登录,times,http,Ultimates,Audiobook,21
2910	2014-05-29 20:53:20.027653	http://www.douban.com/group/topic/53172356/	北京爱百福·灯塔之光招聘照顾视障孤儿志愿者 - 豆瓣	志愿者申请表下载地址：http://pan.baidu.com/s/1gj4dj 如果无法下载，可发简历至我的邮箱，注明可以提供志愿服务的【起始时间】。 目前机构急缺【六月】志愿者，欢迎 ...	\N	1	0	0	0	3	2014-05-24 20:53:19.224223	爱百福,24,2014,志愿者,05,照顾,15,小组,梅妆,手试,com,时间,删除,视障,http,...,孤儿,欢迎
2906	2014-05-29 20:53:19.994268	http://www.douban.com/group/topic/53208362/	思维GHOSTWin7x86系统技术员装机V1.0版本 - 豆瓣	百度网盘http://pan.baidu.com/s/1ntv5KRR 密码：moyl 转自于：http://bbs.swxp.net/forum.php?mod=viewthread&tid=8&extra=page%3D1 · 喜欢 · 回应 推荐 喜欢 只 ...	\N	1	0	0	0	3	2014-05-25 20:53:19.22217	小组,邀请,系统,安装,版本,思维,http,V1,GHOSTWin7x86,2014,10,登录,技术员,装机,选择,times,swxp,quot
2903	2014-05-29 20:53:19.969281	http://www.douban.com/group/topic/52421430/	给大家送电子书哦，又可以交朋友，乐啊乐啊···· - 豆瓣	需要的朋友可以去我的朋友圈下载我的薇信zyy0200（不注明的不加不想收到陌生人的骚扰） 链接: http://pan.baidu.com/s/1bnktFdl 如果觉得可以的话，下载的朋友们 ...	\N	1	0	0	0	3	2014-05-07 00:00:00	05,2014,删除,15,16,12,14,13,11,08,17,09,邻水,21,10,楼主,督查,微信,38
2897	2014-05-29 20:53:19.919263	http://www.douban.com/group/topic/52883464/	2014年宝宝取名字大全(含周易起名软件破解版) - 豆瓣	推荐非常好用的宝宝取名软件,需要的妈妈可以下载试下,免费的最新周易起名大师15.0免费版下载试用http://pan.baidu.com/share/linkshareid1329329877u,本人做 ...	\N	1	0	0	0	3	2014-05-17 00:00:00	起名,周易,...,软件,取名,com,http,www,qm6,算命,免费,打分,宝宝,起名网,生辰八字,大师,取名字,2014,正版
2895	2014-05-29 20:53:19.902585	http://www.douban.com/group/topic/52336814/	摄影教程PPT文件，摄影的朋友看过来哦。 - 豆瓣	4希望自己熟练使用PS软件精确调色、修片，饰润，把摄影照片化腐朽为神奇的摄友。快点看过来哦··· 这是地址链接， : http://pan.baidu.com/s/1mgkbw3e 要的朋友 ...	\N	1	0	0	0	3	2014-05-05 00:00:00	摄影,摄友,小组,PPT,教程,照片,过来,熟练,登录,times,com,2014,05,拍出,用光,文件,朋友,喜欢,能够
2889	2014-05-29 20:53:19.852534	http://www.douban.com/group/topic/53249548/	【视频资源分享】剑桥国际英语教程(初、中级) - 豆瓣	... 适合各个阶段的英语学习者，请速收藏（含试听视频）。下载再送生活必备词汇集一本（请打开网盘免费索取）。 下载地址：http://pan.baidu.com/s/1sjpsgMh 密码：jum2.	\N	1	0	0	0	3	2014-05-26 20:53:19.213801	2014,05,删除,29,26,小组,视频,17,英语,下载,长腿,27,22,09,...,登录,资料,口语
2882	2014-05-29 20:53:19.79421	http://www.douban.com/group/topic/52641710/	秦晖5.12北大法学院讲座预告：【历史与现实中的土... - 豆瓣	头头儿 (我不想再拥有，我不能再失去) 2014-05-24 21:31:53. 感谢@哲别之箭分享的音频 秦晖历史与现实中的土地问题 http://pan.baidu.com/s/1c0gUT2K. 删除.	\N	1	0	0	0	3	2014-05-12 00:00:00	2014,秦晖,05,15,删除,26,头头儿,http,com,12,...,漫游,小组,5.12,00,北大法学院,讲座,现实
2988	2014-05-29 20:53:52.516265	http://www.douban.com/group/topic/52372174/	想知道我是怎样用35元游乐重庆的吗？进来告诉你 - 豆瓣	... 给那些爱好旅游者，免得要去又不看，糟蹋好东西，所以在这儿，咱有一个小小的请求，想要知道如何旅旅省钱的就和我交个朋友！ http://pan.baidu.com/s/1pJK2f83	\N	0	0	0	0	3	2014-05-06 00:00:00	\N
2990	2014-05-29 20:53:52.53291	http://www.douban.com/group/topic/52385316/	轻松说粤语【免费分享零基础粤语视频教程大全】！ - 豆瓣	链接: http://pan.baidu.com/s/1hqmRusO，资料是我自己整理的，或是自己在网上买的，不喜勿喷，不要浪费我辛苦的资料。谢谢!!! 10人 喜欢 喜欢 · 回应 推荐 喜欢 只看 ...	\N	0	0	0	0	3	2014-05-06 00:00:00	\N
2992	2014-05-29 20:53:52.549573	http://www.douban.com/group/topic/52520131/	赠送化妆教程、速来打包。 - 豆瓣	来自: 秘鲁的麋鹿 2014-05-09 12:30:58. 所以资料已经分享到朋友圈。链接: http://pan.baidu.com/s/1pJuKKbx 化妆视频全教程. 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	0	0	0	0	3	2014-05-09 00:00:00	\N
2996	2014-05-29 20:53:52.582912	http://www.douban.com/group/topic/52320659/	佳作，故事，小说膨胀中··朋友请过来。·· - 豆瓣	我还有更多国外国内文学经典集 要的朋友可以加我的微信zyy0200，加的时候要注明，书籍。链接地址，http://pan.baidu.com/s/1sjCrwNb · 喜欢 · 回应 推荐 喜欢 只看 ...	\N	0	0	0	0	3	2014-05-05 00:00:00	\N
2997	2014-05-29 20:53:52.591306	http://www.douban.com/group/topic/52324226/	学摄影视频教程，想要的速度来了 - 豆瓣	光说不练假把式，又说又练真把式. 这是地址链接， : http://pan.baidu.com/s/1mgkbw3e 要的朋友可以加我的微信zyy0200，加的时候要注明，摄影素材密码啊。	\N	0	0	0	0	3	2014-05-05 00:00:00	\N
2989	2014-05-29 20:53:52.524587	http://www.douban.com/group/topic/52209897/	【节目】WCS 20140419 Chart 14-16 - 豆瓣	或者到以下百度网盘地址下载本周节目或往期节目： http://pan.baidu.com/share/link?shareid=1890060508&uk=2853545879 后记: 如果你想回顾往期的节目，请 ...	\N	1	0	0	0	3	2014-05-02 00:00:00	Chart,World,节目,Show,amp,week,14,WCS,歌曲,DC,小组,http,20140419,2014,16,排行榜,hottest,global
2991	2014-05-29 20:53:52.541259	http://www.douban.com/group/topic/52645168/	鲸鱼岛电子书分享 - 豆瓣	http://pan.baidu.com/wap/link?shareid=3190029636&uk=1094384564&uid=1399872303440_304&ssid=e3ea1ab6e21edcc3327ed70748e596ae.	\N	1	0	0	0	3	2014-05-12 00:00:00	2014,05,解压,12,删除,HOLYc,29,小组,kindle,com,Happiness,Cyanide,10,密码,不行,解压缩,我下,xxx
3002	2014-05-29 20:53:52.632967	http://www.douban.com/group/topic/52386536/	一步一步学摄影，学完这128集视频，，你就是摄影啦... - 豆瓣	http://pan.baidu.com/s/1o67DJAU 下载视频需要密码，喜欢的豆豆们加我徽信qinshan8100 密码都分享到我的朋友圈啦，，，. 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	0	0	0	0	3	2014-05-06 00:00:00	\N
3007	2014-05-29 20:53:52.67469	http://www.douban.com/group/topic/52750591/	不错的瑜珈教程~想要的来下载吧 - 豆瓣	... 了，今天本卤煮换种方式给大家分享，那就自己去下，免得我传的麻烦！ 地址在这里哈！我的网盘：http://pan.baidu.com/s/1pJEx5Kv提取码请加威信5963381 获取	\N	0	0	0	0	3	2014-05-14 00:00:00	\N
3008	2014-05-29 20:53:52.683009	http://www.douban.com/group/topic/52561989/	【速读、那些你不知道的事~】这个能力很重要~ - 豆瓣	来自: 难忆梦醒梦醉一 2014-05-10 12:02:36. http://pan.baidu.com/s/1kTwoAcZ · 喜欢 · 回应 推荐 喜欢 只看楼主 · 悦来客栈卫二小 (http://t.cn/8s1Bml1) 2014-05-10 ...	\N	0	0	0	0	3	2014-05-10 00:00:00	\N
3003	2014-05-29 20:53:52.641312	http://movie.douban.com/subject/24741638/comments	音乐救赎者短评 - 豆瓣电影	1 有用 Brutal Ivan 2014-01-07. metalhead的日常http://pan.baidu.com/wap/link?uk=806276643&shareid=3834886921&third=0 ...	\N	0	0	0	0	3	2014-05-21 00:00:00	2014,02,金属,电影,01,喜剧,黑金属,05,救赎,音乐,amp,04,03,短评,摇滚,黑金,法国,重金属
3016	2014-05-29 20:53:52.749697	http://movie.douban.com/subject/25817522/comments?sort=new_score	揭秘神探夏洛克短评 - 豆瓣电影	这才知道自己对原著是多么无知…… iPhone. 1 有用 深夜声咽 2014-01-24. 无无聊聊刷两遍，isherlock字幕组720P：http://pan.baidu.com/s/1gd1dTR1 密码: y49j. 0	\N	0	0	0	0	3	2014-05-03 00:00:00	2014,02,03,01,原著,夏洛克,04,神探,gt,05,第三季,短评,电影,揭秘,http,com,49,30
3015	2014-05-29 20:53:52.741365	http://www.douban.com/group/topic/53043462/	分享~~ 超美盘发视频教程来咯~姑娘们来拿吧~~	菇凉们没事可以拿着学哈，视频教程有步骤讲解的，也是有老师教的，很简单的。 要的妹纸准备好内存哈， 地址在这： http://pan.baidu.com/s/1o66Y75C 提取码加我 ...	\N	1	0	0	0	3	2014-05-21 00:00:00	楼主,2014,05,21,微信,5963381,请加,存颗,删除,教程,14,女王,13,资料,谢谢,小组,15,分享
3014	2014-05-29 20:53:52.733018	http://www.douban.com/group/topic/52613075/	蓝宇是被剪过的吧？原版157分钟？ - 豆瓣	土拨鼠之日 2014-05-11 20:26:05. 小说北京故事网盘地址 http://pan.baidu.com/share/link?shareid=453958897&uk=1998870170. 删除. 赞 回应 ...	\N	1	0	0	0	3	2014-05-11 00:00:00	11,05,2014,删除,完整版,如花美眷,22,郭德纲,20,原版,豆油,删减,19,土拨鼠,已豆,考研,床戏,157,关锦鹏
3013	2014-05-29 20:53:52.724702	http://movie.douban.com/subject/24751754/questions/3519/answers/10086	《前任攻略》 前任那场婚礼韩庚带夏露逃跑的插曲？ - 豆瓣电影	自己在电影里截取的，把新娘尖叫那一段给做掉了，百度网盘: http://pan.baidu.com/s/1gdIbuoV 我是雷锋不用谢. 我来回应. 韩庚声音是自己配的吗？ 余飞为什么会 ...	\N	0	0	0	0	3	2014-05-01 00:00:00	前任,攻略,电影,韩庚,带夏露,2014,回答,插曲,那场,战警,gt,27,逃跑,婚礼,问题,影院,折叠
3011	2014-05-29 20:53:52.708032	http://site.douban.com/119902/widget/notes/5123434/note/350450182/	奥斯汀梦幻别墅 - 豆瓣	... 融入新的元素，特别是入口处景观，巧妙的维持了传统和现代之间的平衡。 下载PDF：http://dl.vmall.com/c03anz3dmq 或http://pan.baidu.com/s/1gdCCix9. 分享到.	\N	1	0	0	0	3	2014-05-12 00:00:00	com,奥斯汀,javascript,http,gt,2014,浏览器,建筑设计,梦幻,建筑,设计师,别墅,请换,我来,vmall,rights,reserved,pan,layan
3009	2014-05-29 20:53:52.69136	http://www.douban.com/group/topic/52380277/	6000本言情小说分享给豆油 - 豆瓣	6000本言情小说分享给豆油，你们准备好了吗，速度来哦。，要的朋友可以加我的微信zyy0200，加的时候要注明，电子书密码， 链接: http://pan.baidu.com/s/ ...	\N	1	0	0	0	3	2014-05-06 00:00:00	小组,言情小说,6000,2014,...,登录,书单,豆油,times,http,com,14,06,05,分享,注册,喜欢,推荐
3010	2014-05-29 20:53:52.699684	http://www.douban.com/group/topic/52559272/	【资源】 手帐手绘教程~~14本书哦~！！！ 有木有需... - 豆瓣	来自: 葡萄干干 2014-05-10 10:50:05. 有需要的吗？？？ 希望大家能顶起来造福更多人哦 这是链接地址：http://pan.baidu.com/s/1ntuhMul · 3人 喜欢 喜欢 · 回应 推荐 ...	\N	1	0	0	0	3	2014-05-10 00:00:00	05,2014,删除,16,17,15,14,18,23,21,楼主,12,20,11,10,不会,22,13,24
3004	2014-05-29 20:53:52.649645	http://www.douban.com/group/topic/52637614/	分享电子书，无需邮箱，自行下载 - 豆瓣	手有余香=========== 海量电子书，下到手软。 如果觉得对您有帮助请帮忙顶下帖子，不要让帖子沉了。谢谢了！！！ http://pan.baidu.com/s/1kTwoAcZ链接地址.	\N	1	0	0	0	3	2014-05-12 00:00:00	05,2014,删除,16,之影,若即若离,17,14,19,18,24,22,13,23,15,10,楼主,21,20
3001	2014-05-29 20:53:52.624655	http://www.douban.com/group/topic/52859737/	Q335期，目害 - 豆瓣	不知道你们看过没，反正我在超市翻开的时候整个人都瞎了. 19页大放送. 第一页. 瞎了瞎了. 传了个电子版：http://pan.baidu.com/s/1bnjEpkj 大家感受一下. 喜欢.	\N	1	0	0	0	3	2014-05-17 00:00:00	小组,目害,Q335,登录,猪文迪,times,com,2014,...,注册,复婚,话题,交流,手机,电子版,行摄,大放送,吸土
3006	2014-05-29 20:53:52.666296	http://www.douban.com/group/topic/52648981/	冰激凌教程 - 豆瓣	来自: 太可恶 2014-05-12 14:46:35. 链接: http://pan.baidu.com/s/1nt8whjN 冰淇淋制作教程. 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	1	0	0	0	3	2014-05-12 00:00:00	2014,05,删除,14,18,21,22,17,15,23,16,13,12,19,楼主,29,26,24
3012	2014-05-29 20:53:52.716366	http://www.douban.com/group/topic/52746873/	手绘教程，要的来取吧！ - 豆瓣	来自: 存颗女王心 2014-05-14 16:29:08. 链接： http://pan.baidu.com/s/1rhKFc 提取码加我威信获取。 4人 喜欢 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	1	0	0	0	3	2014-05-14 00:00:00	2014,05,删除,17,教程,14,请加,微信,存颗,5963381,36,16,女王,相忘,相濡以沫,楼主,染上,尘埃
3047	2014-05-29 20:54:27.155124	http://www.douban.com/group/topic/52388754/	摄影视频教程 - 豆瓣	光说不练假把式，又说又练真把式. 这是地址链接， : http://pan.baidu.com/s/1mgkbw3e 要的朋友可以加我的微信zyy0200，加的时候要注明，摄影素材密码啊。	\N	0	0	0	0	3	2014-05-06 00:00:00	\N
3005	2014-05-29 20:53:52.657985	http://www.douban.com/group/topic/53053550/	【节目】WCS 20140510 Chart 14-19~John Martin的回归 - 豆瓣	或者到以下百度网盘地址下载本周节目或往期节目： http://pan.baidu.com/share/link?shareid=1890060508&uk=2853545879 后记: 如果你想回顾往期的节目，请 ...	\N	1	0	0	0	3	2014-05-21 00:00:00	Chart,World,节目,Show,amp,quot,week,14,歌曲,WCS,Martin,John,DC,20140510,小组,世界,http,2014
2993	2014-05-29 20:53:52.557932	http://www.douban.com/group/topic/52763249/	2014.05.14 反思性善论@ECNU - 豆瓣	百度云盘http://pan.baidu.com/s/1bniYm2z 腾讯微云http://url.cn/Mzgzv7 今日活动通知 http://www.philo.ecnu.edu.cn/s/169/t/189/94/c9/info103625.htm	\N	1	0	0	0	3	2014-05-14 00:00:00	2014,05,删除,16,失效,小组,小知儿,17,链接,多试,陈嘉映,http,SM,SH,55555,14,登录
2994	2014-05-29 20:53:52.566242	http://site.douban.com/topfloorcircus/?s=338599	顶楼的马戏团的小站（豆瓣音乐人）	顶楼的马戏团成立十年以来全部四张专辑打包下载：http://pan.baidu.com/share/link?shareid=203836&uk=724874371&third=15 《上海市流行摇滚金曲十三叔》 ...	\N	2	0	0	0	3	2014-05-01 00:00:00	2013,http,com,amp,2014,02,12,11,05,马戏团,顶楼,item,25,22,20,19,01
2974	2014-05-29 20:53:52.366242	http://www.douban.com/group/topic/52212918/	施特劳斯研究资料下载 - 豆瓣	http://pan.baidu.com/s/1dDqvglj 另：本人正在寻找以下书，若谁能帮我找一下它们的电子书，我将不胜感激。不需要全部都找到，有一本是一本，欲帮助者豆邮联系。	\N	4	0	0	0	3	2014-05-02 00:00:00	com,pan,http,baidu,Seth,Plato,Benardete,小组,Ritter,Der,2014,施特劳斯,Tragedy,Philebus,Life,Ga,Comedy,05
2972	2014-05-29 20:53:52.349454	http://www.douban.com/group/topic/52368450/	科幻的真实历史2014英國廣播公司美國台 - 豆瓣	2014-05-06 10:46:19. 科幻的真实历史2014英國廣播公司美國台 http://www.bbcamerica.com/real-history-of-science-fiction/ · http://pan.baidu.com/s/1o6DJ4Em.	\N	1	0	0	0	3	2014-05-06 00:00:00	2014,小组,05,英國,美國台,灵书妙,廣播,妈个,http,com,Richard,Castle,10,登录,科幻,之去,times,HomeAnimator
2969	2014-05-29 20:53:52.324506	http://www.douban.com/group/topic/52429861/	继续推广我的图书馆。 - 豆瓣	来自: 涂蜀黍(强硬科学主义者，无神论者！) 2014-05-07 13:26:26. http://pan.baidu.com/s/17oamv 密码:jke4 以前发过一次，再在继续发。扩充到3万多本了。	\N	1	0	0	0	3	2014-05-07 00:00:00	2014,05,07,删除,13,08,14,小组,28,26,25,22,19,03,读书,登录,楼主,喜欢
2971	2014-05-29 20:53:52.341159	http://www.douban.com/group/topic/52681285/	纯真人手工软陶制作教程。 - 豆瓣	链接: http://pan.baidu.com/s/1eQ02ZeU 软陶真人公仔制作教程材料 感兴趣的朋友可以加我的微信。zyy0200，所有资料已经分享到了朋友圈。 喜欢 · 回应 推荐 喜欢 ...	\N	1	0	0	0	3	2014-05-13 00:00:00	软陶,公仔,小组,DIY,教程,com,2014,13,登录,手工,烧制,橡皮泥,制作,times,40,05,分享,小豆
2951	2014-05-29 20:53:52.174394	http://music.douban.com/doulist/3566363/	2014奇葩备选 - 豆瓣音乐	表演者: 魏如萱 出版者: 添翼创越. 评语 : 宣告着台湾绝大部分女歌手从2013年继续low到2014 有史以来最难听的魏如萱。DL：http://pan.baidu.com/s/1bnoxECv 都来 ...	\N	0	0	0	0	3	2014-05-11 00:00:00	middot,表演者,出版者,2014,评语,http,com,03,田馥,模王,douban,音乐,收听,方大同,难听,唱片,葱头,魏如,郑聪
2959	2014-05-29 20:53:52.241097	http://www.douban.com/group/topic/52644806/	会摄影，不会修片，那咋成，我这里有教你处理相片的 - 豆瓣	... 实现咋办？？？我这里有教学j教程，此教程并不是网络一般教程.总共70集,我保证你学完后P图什么的都没有问题~ 这是链接地址：http://pan.baidu.com/s/1sjwI5rv.	\N	1	0	0	0	3	2014-05-12 00:00:00	小组,quot,修片,2014,登录,教程,有教,times,com,26,13,12,05,注册,楼主,相片,摄影
2953	2014-05-29 20:53:52.191079	http://www.douban.com/group/topic/52297647/	求指教 - 豆瓣	Jenny 2014-05-05 17:04:14. 可以做黄金投资，也可以买基金产品，这里有份基金产品的资料，你可以看一下http://pan.baidu.com/s/1bngpVA3 提取码：5doy. 删除.	\N	1	0	0	0	3	2014-05-04 00:00:00	05,2014,删除,乖乖,19,常志伟,收益,理财产品,陆金,宜信,22,com,楼主,月入,p2p,04,信托
2950	2014-05-29 20:53:52.16605	http://www.douban.com/group/topic/52568111/	收集的手绘教程资料，送了 - 豆瓣	小组、话题. 收集的手绘教程资料，送了. 不完美的女人. 来自: 不完美的女人 2014-05-10 15:10:07. http://pan.baidu.com/s/1sjrrOlf链接. 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	1	0	0	0	3	2014-05-10 00:00:00	05,2014,删除,18,13,15,12,17,14,11,21,微信,24,16,46,19,10,23,22
2949	2014-05-29 20:53:52.157731	http://www.douban.com/people/different_class/	Lucide - 豆瓣	格林童话：http://pan.baidu.com/share/link?shareid=2314028718&uk=3909324753 奇葩嘴工程进行中，欢迎提供素材，非常感谢！ 我盗图但是不盗未成年人发图和 ...	\N	2	0	0	0	3	2014-05-16 00:00:00	middot,Lucide,amp,2014,quot,com,Cocker,http,口音,gt,Pulp,Jarvis,05,维斯,uk,blur,26,......,...
2933	2014-05-29 20:53:52.024318	http://site.douban.com/107390/widget/notes/139646/note/348390764/	【中字】【荷兰】吹奏（1958） - 豆瓣	校对版srt中字：http://pan.baidu.com/share/link?shareid=3967960730&uk=1060196341（密：b98l） 原译：白马如练 校对：多不利登. 分享到. 推荐 7人. 4人 喜欢 喜欢.	\N	1	0	0	0	3	2014-04-30 00:00:00	中字,com,1958,http,gt,douban,2014,01,校对,吹奏,javascript,20,2.0,翻译,字幕,浏览器,荷兰,链接,小组
2931	2014-05-29 20:53:52.007601	http://www.douban.com/group/topic/52411409/	轻松说粤语【免费分享零基础粤语视频教程大全】！ - 豆瓣	链接: http://pan.baidu.com/s/1hqmRusO，资料是我自己整理的，或是自己在网上买的，不喜勿喷，不要浪费我辛苦的资料。谢谢!!! 4人 喜欢 喜欢 · 回应 推荐 喜欢 只看 ...	\N	1	0	0	0	3	2014-05-06 00:00:00	2014,05,粤语,小组,07,登录,删除,分享,视频教程,times,com,46,13,...,喜欢,注册,大全,资料
2930	2014-05-29 20:53:51.999251	http://www.douban.com/group/topic/52485055/	【名媛养成】《名媛美容术打造青春美丽的10堂课》... - 豆瓣	下载地址：http://pan.baidu.com/s/1mguQLU4解压码. - 加zhaoxixigirl 获取。加我时验证写“解压码” 索取。 这么好的分享，帖子沉了挺可惜的，为了让更多的MM能看 ...	\N	1	0	0	0	3	2014-05-08 00:00:00	名媛,小组,美容术,堂课,2014,10,...,登录,养成,times,http,com,MM,23,15,08,05,青春
2927	2014-05-29 20:53:51.974212	http://www.douban.com/group/topic/52736570/	豆瓣这里有没有关八饭啊~五湖四海都行，本人坐标广...	豆瓣这里有没有关八饭啊~五湖四海都行，本人坐标广东深圳，绿担紫担为主，无cp雷区，同好请进~. pan.baidu.com. eito77给您加密分享了文件请输入提取密码：提取 ...	\N	1	0	0	0	3	2014-05-14 00:00:00	小组,小白二,关八饭,2014,...,登录,五湖四海,都行,坐标,杰西,兔王,times,com,14,13,05,注册,有没有
2948	2014-05-29 20:53:52.149387	http://www.douban.com/group/topic/52423738/	以前购买的健身舞全套，还有超多视频!免费送了 - 豆瓣	... 懒女人，没有丑女人，姐妹们都行动起来吧! 想要的同学可以加我的WX：zyy0200.我已经分享到朋友圈了，美女们去拿吧。。 链接: http://pan.baidu.com/s/1eQxKJey.	\N	1	0	0	0	3	2014-05-07 00:00:00	05,2014,删除,15,14,13,18,17,亚剑宝,16,10,11,09,19,12,楼主,24,21,23
2995	2014-05-29 20:53:52.574591	http://www.douban.com/group/topic/52874871/	【日行一善】想学PS没有教程和素材的来~~ - 豆瓣	不错的PS教程，视频讲解的很详细 有超多素材，笔刷 一直在关注PS这块， 以后还会有很多更新的内容 大家要资料的直接来吧： 地址：链接: http://pan.baidu.com/s/ ...	\N	1	0	0	0	3	2014-05-17 00:00:00	2014,17,15,05,优益,删除,PS,14,13,12,教程,小组,...,登录,喜欢,素材
3017	2014-05-29 20:53:52.758054	http://www.douban.com/group/topic/52559175/	【资源】 手帐手绘教程~~14本书哦~！！！ 有木有需... - 豆瓣	来自: 葡萄干干 2014-05-10 10:47:35. 有需要的吗？？？ 希望大家能顶起来造福更多人哦 这是链接地址：http://pan.baidu.com/s/1ntuhMul · 喜欢 · 回应 推荐 喜欢 只 ...	\N	1	0	0	0	3	2014-05-10 00:00:00	05,2014,删除,15,18,14,21,22,17,16,12,13,20,11,23,10,24,19
3019	2014-05-29 20:54:26.871503	http://www.douban.com/group/topic/52333981/	【新粤语视频教程】分享给爱他的你 - 豆瓣	链接: http://pan.baidu.com/s/1jGys69K 密码: gk6g这是其中一点，资料是我自己整理的，或是自己在网上买的，不喜勿喷，不要浪费我辛苦的资料。谢谢. 3人 喜欢 喜欢.	\N	0	0	0	0	3	2014-05-05 00:00:00	\N
3020	2014-05-29 20:54:26.884295	http://www.douban.com/group/topic/52429011/	6000本言情小说合集，小伙伴们速度来取。 - 豆瓣	需要的朋友可以去我的朋友圈下载我的薇信zyy0200（不注明的不加不想收到陌生人的骚扰） 链接: http://pan.baidu.com/s/1dD265dn 如果觉得可以的话，下载的朋友 ...	\N	0	0	0	0	3	2014-05-07 00:00:00	\N
3022	2014-05-29 20:54:26.904802	http://www.douban.com/group/topic/52390291/	废话不多说，给友友送书了，速度来取啊. - 豆瓣	... 还有很多其他学习的资源哦。，. 需要的朋友可以去我的朋友圈下载我的薇信zyy0200（不注明的不加不想收到陌生人的骚扰） 链接: http://pan.baidu.com/s/1bnktFdl.	\N	0	0	0	0	3	2014-05-06 00:00:00	\N
3023	2014-05-29 20:54:26.91317	http://www.douban.com/group/topic/52377319/	摄影教程免费送啦。。。。不要钱的哦，豆豆们还在... - 豆瓣	http://pan.baidu.com/s/1o67DJAU 下载视频需要网址，喜欢的豆豆们加我徽信qinshan8100 密码都分享到我的朋友圈啦，，，. 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	0	0	0	0	3	2014-05-06 00:00:00	\N
3025	2014-05-29 20:54:26.938195	http://www.douban.com/group/topic/52962956/	Body revolution开练-露珠自我救赎虐肉之旅 - 豆瓣	br全部视频分享：http://pan.baidu.com/s/1kTG8jfL 我的基数 身高：165厘米 体重：60公斤 目标 我的目标不基于体重和围度，而是要把90天这操完整的坚持下来！	\N	1	0	0	0	3	2014-05-19 00:00:00	05,2014,删除,陈拉飞,27,图图,神经质,健身,热爱,19,10,...,28,20,露珠,有氧,无氧,吃好饭,13
3024	2014-05-29 20:54:26.929967	http://www.douban.com/group/topic/52487300/	《牛尔的美白书全集》，想要美白的MM去下载吧！ - 豆瓣	下载地址：http://pan.baidu.com/s/1ntDfgNZ 解压码. +V信： han03200 加我时验证写“解压码” 索取。 这么好的分享，帖子沉了挺可惜的，为了让更多的MM能看到，喜欢 ...	\N	1	0	0	0	3	2014-05-08 00:00:00	小组,MM,2014,登录,美白书,美白,牛尔,times,http,com,16,08,05,03,...,..,解压,注册
3021	2014-05-29 20:54:26.896565	http://www.douban.com/group/topic/52650670/	梁翘柏失意年代：被遗忘的一把手术刀320K - 豆瓣	冬青树 倾城 南国之舞 萨塔尔与合成音色 艾捷克， 手鼓与氛围萨塔尔， 手鼓与氛围 手鼓与氛围 在到处之间找我 链接: http://pan.baidu.com/s/1dDDweFR 密码: ykxl.	\N	1	0	0	0	3	2014-05-12 00:00:00	320K,可乐,小组,梁翘柏,com,MP3,手术刀,手鼓,专辑,登录,失意,遗忘,全碟,times,2014,15,氛围,注册
3027	2014-05-29 20:54:26.971596	http://www.douban.com/group/topic/52323355/	专业的摄影教程PPT文件，摄影的朋友看过来哦。 - 豆瓣	4希望自己熟练使用PS软件精确调色、修片，饰润，把摄影照片化腐朽为神奇的摄友。快点看过来哦··· 这是地址链接， : http://pan.baidu.com/s/1mgkbw3e 要的朋友 ...	\N	0	0	0	0	3	2014-05-05 00:00:00	\N
3028	2014-05-29 20:54:26.97986	http://www.douban.com/group/topic/52531656/	粤语教材12套打包分享要的联系楼主 - 豆瓣	11.学讲广州话(mp3+lrc)版本 12.粤语一学就会MP3 想学粤语的亲们，也可以直接加楼主微信直接打包转轴哦~ 微信号：haimei020 这是链接： http://pan.baidu.com/s/ ...	\N	0	0	0	0	3	2014-05-09 00:00:00	\N
3043	2014-05-29 20:54:27.121777	http://www.douban.com/group/topic/52299393/	【赠送瑜伽视频+编发教程】想学瑜伽和编发型的快来... - 豆瓣	还是自己去下载！地址在这里哈！我的网盘：http://pan.baidu.com/disk/home#from=share_pan_logo 加我威信时发送验证“瑜伽” 索取密码提取. 这是编发教程。	\N	0	0	0	0	3	2014-05-04 00:00:00	\N
3045	2014-05-29 20:54:27.138452	http://www.douban.com/group/topic/52562138/	【速读、那些你不知道的事~】这个能力很重要~ - 豆瓣	【速读、那些你不知道的事~】这个能力很重要~. 难忆梦醒梦醉一. 来自: 难忆梦醒梦醉一 2014-05-10 12:08:09. 这是地址链接：http://pan.baidu.com/s/1kTwoAcZ.	\N	0	0	0	0	3	2014-05-10 00:00:00	\N
3041	2014-05-29 20:54:27.105072	http://movie.douban.com/subject/1304605/	寂寞之鸽(豆瓣) - 豆瓣电影	http://pan.baidu.com/share/link?shareid=78218&uk=1308965170 0 有用 2回应 ... http://pan.baidu.com/share/link?shareid=78218&uk=1308965170 1 有用 3回应 ...	\N	0	0	0	0	3	2014-05-26 20:54:26.827173	之鸽,quot,TV,西部片,短评,gt,2014,2011,13,05,电视剧,寂寞,11,影评,电影,winning
3034	2014-05-29 20:54:27.046748	http://site.douban.com/119902/widget/notes/5123434/note/350451068/	福州五四北泰禾广场 - 豆瓣	... 着游客们纷纷来此驻足休憩、购物休闲，更使得这里成为了人们社交娱乐的新地标。 下载PDF：http://dl.vmall.com/c0n13qptci 或http://pan.baidu.com/s/1kTkJDQ3.	\N	1	0	0	0	3	2014-05-12 00:00:00	福州,北泰禾,com,五四,商场,广场,javascript,http,gt,2014,12,设计,浏览器,独特,建筑设计,建筑,购物,娱乐
3046	2014-05-29 20:54:27.146811	http://www.douban.com/group/topic/52684987/	857本优秀Kindle经典免费中文电子书。 - 豆瓣	来自: 梁山好汉88 2014-05-13 10:57:00. 链接: http://pan.baidu.com/s/1hqDqebi 857本优秀Kindle经典免费中文电子书。 1人 喜欢 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	1	0	0	0	3	2014-05-13 00:00:00	小组,2014,13,免费中文,Kindle,857,05,登录,times,com,57,10,电子书,注册,经典,优秀,二手,蚊子
3037	2014-05-29 20:54:27.071771	http://www.douban.com/group/topic/52558984/	【资源】 手帐手绘教程~~14本书哦~！！！ 有木有需... - 豆瓣	来自: 翟家佳 2014-05-10 10:41:57. 有需要的吗？？？ 希望大家能顶起来造福更多人哦 这是链接地址：http://pan.baidu.com/s/1ntuhMul · 5人 喜欢 喜欢 · 回应 推荐 ...	\N	1	0	0	0	3	2014-05-10 00:00:00	2014,05,删除,臭蛋,16,14,德行,17,15,楼主,11,21,20,18,12,13,22,23,10
3035	2014-05-29 20:54:27.055074	http://www.douban.com/group/topic/52523053/	分享【零基础ps手绘速成视频教程】自己的言情女主角 - 豆瓣	来自: 05海经回忆 2014-05-09 13:42:21. 这是链接地址加的时候请注明http://pan.baidu.com/s/1sjwI5rv · 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	1	0	0	0	3	2014-05-09 00:00:00	05,2014,删除,16,18,14,15,17,13,com,19,玫瑰,10,http,12,23,21,22,11
3031	2014-05-29 20:54:27.013391	http://www.douban.com/group/topic/52618524/	【下载】【Adobe Photoshop CC】简体中文完整版 - 豆瓣	... 能够轻松创造出各种奇幻的效果。 大小：1.31 GB语言：中文最新版本：2013-06-28 适合系统：Win8/Win7/Vista/Win8.1. 下载地址：http://pan.baidu.com/s/1ntBJVVN.	\N	1	0	0	0	3	2014-05-11 00:00:00	小组,Photoshop,PS,2014,简体中文,完整版,CC,Adobe,05,登录,times,com,Win8,12,00,...,注册,下载
3033	2014-05-29 20:54:27.038438	http://www.douban.com/group/topic/52598812/	那什么一步一步学摄影的视频 - 豆瓣	来自: Milk Liao(过去已成为历史,将来还木有到来) 2014-05-11 11:59:48. http://pan.baidu.com/s/1iufsM 这是下载地址 128集，加微信什么的太恶心了. 3人 喜欢 喜欢.	\N	1	0	0	0	3	2014-05-11 00:00:00	2014,11,05,小组,12,登录,楼主,删除,摄影,一步,times,com,注册,喜欢,推荐,视频,海上花,无码
3026	2014-05-29 20:54:26.954888	http://www.douban.com/group/topic/52559127/	【资源】 手帐手绘教程~~14本书哦~！！！ 有木有需... - 豆瓣	来自: 葡萄干干 2014-05-10 10:46:18. 有需要的吗？？？ 希望大家能顶起来造福更多人哦 这是链接地址：http://pan.baidu.com/s/1ntuhMul · 喜欢 · 回应 推荐 喜欢 只 ...	\N	1	0	0	0	3	2014-05-10 00:00:00	05,2014,删除,14,17,16,孤寂,23,13,18,15,22,楼主,21,11,20,19,10,25
3029	2014-05-29 20:54:26.99662	http://www.douban.com/group/topic/53279973/	【文学】源氏物语——丰子恺译本注释全	来自: 易水寒 2014-05-27 14:34:21. 传送门：http://pan.baidu.com/s/1jGsonDO 下载的回个复，你顶我顶大家顶. 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	1	0	0	0	3	2014-05-27 20:54:26.821306	小组,kindle,2014,登录,易水寒,times,com,27,14,05,...,丰子恺,旧书,源氏物语,注册,译本,注释,话题
3032	2014-05-29 20:54:27.030106	http://www.douban.com/group/topic/52579168/	张鸣：帝制并不那么容易被告别 - 豆瓣	张鸣：帝制并不那么容易被告别. 一匪成神冤鬼哭. 来自: 一匪成神冤鬼哭 2014-05-10 20:48:02. http://pan.baidu.com/s/1mgkbBbq · 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	1	0	0	0	3	2014-05-10 00:00:00	小组,张鸣,2014,登录,讲座,冤鬼,成神,怪奇,一匪,times,com,20,05,注册,帝制,居士,录音,告别
3040	2014-05-29 20:54:27.096753	http://www.douban.com/group/topic/52621659/	丛日云《西方政治文明13讲》 - 豆瓣	来自: 怪奇居士 2014-05-11 23:04:30. 《西方政治文明13讲》 讲者：丛日云教授中国政法大学 此君比较敢讲话了 下载：http://pan.baidu.com/s/1c0Ggapa · 喜欢.	\N	1	0	0	0	3	2014-05-11 00:00:00	小组,怪奇,丛日云,13,政治文明,登录,居士,讲座,times,com,2014,注册,录音,西方,话题,六便士,汪晖,手机
3048	2014-05-29 20:54:27.163475	http://www.douban.com/group/topic/52288939/	给大伙分享一个720p的老友记版本 - 豆瓣	2014-05-04 17:04:16. 全十季，有部分删减，英文软字幕。想要的直接下吧。 http://pan.baidu.com/share/link?shareid=1216523300&uk=2520198491 · 1人 喜欢 喜欢.	\N	0	0	0	0	3	2014-05-04 00:00:00	\N
3049	2014-05-29 20:54:27.171583	http://www.douban.com/group/topic/52364587/	轻松说粤语【免费分享零基础粤语视频教程大全】！ - 豆瓣	这是我教程的一点点链接: http://pan.baidu.com/s/1jGys69K 密码: gk6g有着急的朋友也可以加我v信2376656484 分享在朋友圈里的哦 喜欢的我这里还有很多的 ...	\N	0	0	0	0	3	2014-05-06 00:00:00	\N
3050	2014-05-29 20:54:27.180172	http://www.douban.com/group/topic/52427987/	4000部英文原版小说！速来。 - 豆瓣	需要的朋友可以去我的朋友圈下载我的薇信zyy0200（不注明的不加不想收到陌生人的骚扰） http://pan.baidu.com/s/1qWArEsW 如果觉得可以的话，下载的朋友们可以 ...	\N	0	0	0	0	3	2014-05-07 00:00:00	\N
3051	2014-05-29 20:54:27.188477	http://www.douban.com/group/topic/52424965/	穿衣搭配教程免费送啦。。。。爱美的豆豆们赶紧来... - 豆瓣	http://pan.baidu.com/s/1pJPlOUJ 东西只送给感兴趣的人，以免糟蹋了好东西，，下载视频需要密码，，密码都分享在我的朋友圈啦，，，家我徽信qinshan8100 就可以 ...	\N	0	0	0	0	3	2014-05-07 00:00:00	\N
3055	2014-05-29 20:54:27.221623	http://www.douban.com/group/topic/52384327/	免费送给姐妹们的美甲教程大全 - 豆瓣	来自: 凌乱飞逝 2014-05-06 16:02:15. 链接: http://pan.baidu.com/s/1sj6REoP 密码加本人微信揭晓：yuli077. 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	0	0	0	0	3	2014-05-06 00:00:00	\N
3058	2014-05-29 20:54:27.246963	http://www.douban.com/group/topic/52562056/	【速读、那些你不知道的事~】这个能力很重要~ - 豆瓣	来自: 难忆梦醒梦醉一 2014-05-10 12:04:37. http://pan.baidu.com/s/1kTwoAcZ · 喜欢 · 回应 推荐 喜欢 只看楼主 · 泊于水岸 2014-05-10 15:48:31. 不错谢谢楼主大人.	\N	0	0	0	0	3	2014-05-10 00:00:00	\N
3059	2014-05-29 20:54:27.25519	http://www.douban.com/group/topic/52666519/	《牛尔的美白书全集》，想要的MM去下载吧！ - 豆瓣	下载地址：http://pan.baidu.com/s/1bny7gSJ 解压码威信239108992 获取。备注解压码 这么好的分享，帖子沉了挺可惜的，为了让更多的MM能看到，喜欢就顺便顶 ...	\N	0	0	0	0	3	2014-05-12 00:00:00	\N
3066	2014-05-29 20:54:27.313561	http://www.douban.com/group/topic/52284728/	跑鞋的选择 - 豆瓣	... 新人对于跑鞋的选择非常的困惑，还有很多迷恋adidas和nike，之前正好在别的论坛找到一个跑鞋的矩阵图，不敢独享，分享之。 http://pan.baidu.com/s/1c0ipJ8W.	\N	0	0	0	0	3	2014-05-04 00:00:00	\N
3054	2014-05-29 20:54:27.213513	http://movie.douban.com/subject/25792670/discussion/57579937/	南韩居然把北韩想象的这么开放.... - 豆瓣电影	... 没有诶，哪里有买. > 删除 · 兜. 2014-05-17 10:05:21 兜. mobi pan.baidu.com/share/link?shareid=507606&uk=3927497562 其它版本可以在网上搜一搜的 mobi ...	\N	0	0	0	0	3	2014-05-07 00:00:00	05,gt,2014,二硕,北韩,删除,...,朴勋,韩国,北朝鲜,医生,朝鲜,南韩,总理,17,黑市,本书,女友
3064	2014-05-29 20:54:27.296714	http://www.douban.com/group/topic/52424762/	以前购买的郑多燕健身舞全套，还有超多视频!免费送了 - 豆瓣	... 懒女人，没有丑女人，姐妹们都行动起来吧! 想要的同学可以加我的WX：zyy0200.我已经分享到朋友圈了，美女们去拿吧。。 链接: http://pan.baidu.com/s/1eQxKJey.	\N	1	0	0	0	3	2014-05-07 00:00:00	小组,2014,减肥,登录,朋友圈,视频,郑多燕,超多,zyy0200,times,http,com,WX,31,11,07,05,喜欢
3065	2014-05-29 20:54:27.305229	http://www.douban.com/group/topic/52477460/	学摄影视频教程，想要的速度来了 - 豆瓣	来自: 天黑适合杀人 2014-05-08 12:32:14. 这是地址链接， : http://pan.baidu.com/s/1mgkbw3e 要的朋友可以加我的微信zyy0200，加的时候要注明，摄影素材密码啊 ...	\N	1	0	0	0	3	2014-05-08 00:00:00	小组,登录,摄影,视频教程,爱普生,times,com,2014,注册,画画,喜欢,想要,话题,手机,顺丰,行摄,莫晓琪,微信
3057	2014-05-29 20:54:27.238518	http://www.douban.com/group/topic/53075129/	为何恶行往往是政治成功的通行证？——吴思、刘瑜... - 豆瓣	标题：为何恶行往往是政治成功的通行证？——吴思、刘瑜分享《独裁者手册》. http://pan.baidu.com/s/1qWHJSPA · 喜欢 · 回应 推荐 喜欢 只看楼主. 你的回应. 回应请 ...	\N	1	0	0	0	3	2014-05-22 00:00:00	小组,刘瑜,吴思,...,登录,恶行,通行证,讲座,冤鬼,成神,怪奇,一匪,times,com,2014,注册,居士
3053	2014-05-29 20:54:27.205176	http://www.douban.com/group/topic/52831865/	欲海回狂pdf - 豆瓣	来自: 常惭愧 2014-05-16 13:17:45. 欲海回狂pdf http://pan.baidu.com/share/link?shareid=122906&uk=4197022826 · 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	1	0	0	0	3	2014-05-16 00:00:00	2014,16,小组,05,欲海,回狂,主帖,pdf,登录,times,some1,com,13,删除,标题,推荐,注册,惭愧
3052	2014-05-29 20:54:27.196858	http://www.douban.com/group/topic/52644185/	会摄影，不会修片，那咋成，我这里有教你处理相片的 - 豆瓣	我这里有教学j教程，此教程并不是网络一般教程.总共70集,我保证你学完后P图什么的都没有问题~ 这是链接地址：http://pan.baidu.com/s/1sjwI5rv · 1人 喜欢 喜欢.	\N	1	0	0	0	3	2014-05-12 00:00:00	小组,胶片,教程,单反,修片,登录,摄影,奥林巴斯,東京,有教,套机,times,com,50,39,2014,13,1.8,...
3060	2014-05-29 20:54:27.26354	http://site.douban.com/skip/	Skip的小站（豆瓣音乐人）	mixtape下载地址. P.E.I MIXTAPE VOL.1 下载地址http://pan.baidu.com/s/1BwamU. P.E.I MIXTAPE . 歌曲, 播放次数, 播放, 加入播放, 评论, 下载, 分享. , 05.	\N	1	0	0	0	3	2014-05-02 00:00:00	&#,Skip,59407,59402,59400,59394,59393,Prod,05,播放,09,03,下载,关注,小站,Ft,Flava,23,2014
3062	2014-05-29 20:54:27.280052	http://www.douban.com/group/topic/52433641/	《宠物狗美容》，想要狗狗漂亮的MM快去下载吧！ - 豆瓣	http://book.douban.com/subject/2315225/ 下载地址： http://pan.baidu.com/share/link?shareid=1433770441&uk=1142242685 想要狗狗漂亮的MM快去下载吧！	\N	1	0	0	0	3	2014-05-07 00:00:00	狗狗,美容,宠物狗,MM,小组,2014,下载,漂亮,登录,快去,想要,当当网,times,http,douban,com,07,05
3074	2014-05-29 20:54:27.380531	http://www.douban.com/group/topic/52484492/	英语原版小说， - 豆瓣	来自: 无所谓6889 2014-05-08 15:13:04. http://pan.baidu.com/s/1qWArEsW 如果觉得可以的话， 下载的朋友们可以帮助回下帖子吗？让更多的人可以下载，好东西就 ...	\N	0	0	0	0	3	2014-05-08 00:00:00	\N
3086	2014-05-29 20:54:27.655324	http://www.douban.com/group/topic/52377331/	1900部小说免费分享给亲们 - 豆瓣	来自: 千手观音小耳朵 2014-05-06 14:03:23. 1900部小说分享给亲们 链接: http://pan.baidu.com/s/1hqKbtx6 密码+微信: 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	0	0	0	0	3	2014-05-06 00:00:00	\N
3088	2014-05-29 20:54:27.672033	http://www.douban.com/group/topic/52435423/	PS入门到高级课程打包，速来围观、。 - 豆瓣	来自: 呢称为空白 2014-05-07 15:08:58. 这是地址链接， http://pan.baidu.com/s/1o6hV3ia 要的朋友可以加我的微信zyy0200，. 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	0	0	0	0	3	2014-05-07 00:00:00	\N
3073	2014-05-29 20:54:27.371978	http://movie.douban.com/subject/2027000/comments	夜又临短评 - 豆瓣电影	0 有用 eien99 2014-04-08. http://pan.baidu.com/s/1dD9rlIx. 0 有用 姿三四娘 2012-06-18. 为了夏川结衣的露点啊。。。没有网盘的年代真是伤不起还好有了qvod。	\N	0	0	0	0	3	2014-05-12 00:00:00	夏川,2014,12,08,04,结衣,2013,2012,2011,18,17,05,短评,电影,石井,椎名,桔平,根津
3089	2014-05-29 20:54:27.680451	http://site.douban.com/109919/widget/notes/16513632/note/349557119/	【黔书】第03期（20140420） ，有关剪纸、面具、歌曲和蜡染。	夏天到了，北方的太阳很大，树木很少。 今天分享的书有关剪纸、面具、歌曲和蜡染。 【黔书】第03期（20140420） 百度网盘：http://pan.baidu.com/s/1c0y4Qic 书目： ...	\N	1	0	0	0	3	2014-05-07 00:00:00	黔书,20140420,03,蜡染,剪纸,面具,歌曲,无闲草,javascript,gt,com,2014,02,分享,浏览器,夜郎,书籍,百度网
3082	2014-05-29 20:54:27.488723	http://www.douban.com/group/topic/52477608/	学摄影视频教程，想要的速度来了 - 豆瓣	来自: 天黑适合杀人 2014-05-08 12:37:30. 这是地址链接， : http://pan.baidu.com/s/1mgkbw3e 要的朋友可以加我的微信zyy0200，加的时候要注明，摄影素材密码啊 ...	\N	1	0	0	0	3	2014-05-08 00:00:00	小组,摄影,com,2014,登录,自拍,手机,视频教程,times,douban,barbo,12,08,05,注册,秘籍,画画,喜欢
3071	2014-05-29 20:54:27.355264	http://movie.douban.com/subject/25833557/	另一天，另一时《醉乡民谣》原声音乐演唱会(豆瓣) - 豆瓣电影	12 有用 paradox 2014-02-23. http://pan.baidu.com/s/1hqgd7JA. 0 有用 PedroPascaled 2014-02-22. Punch Brothers的主唱怎么辣么萌！ Android. > 更多短评34条 ...	\N	0	0	0	0	3	2014-05-24 20:54:26.841655	2014,Brothers,醉乡,民谣,演唱会,音乐,05,电影,film,Joan,Baez,短评,music,gt,Coen,Avett,2013,1960s
3076	2014-05-29 20:54:27.397007	http://www.douban.com/group/topic/52156701/	天道酬勤VIP输入法注入-11课全{黑客教程小组} - 豆瓣	... 串W宽窄转换 百度网盘最近老是审核不通过，如果有链接不存在的可以联系我。 天道酬勤VIP输入法注入-11课全{黑客教程小组} http://pan.baidu.com/s/1gduuLrH.	\N	1	0	0	0	3	2014-05-01 00:00:00	输入法,教程,注入,小组,黑客,sys32,天道酬勤,课全,VIP,11,登录,注册,times,com,Hook,HTML5,2014,全套
3078	2014-05-29 20:54:27.43063	http://www.douban.com/group/topic/52991081/	新东方英语语法视频讲座大全 - 豆瓣	搜索：. 小组、话题. 新东方英语语法视频讲座大全. 傻啊傻. 来自: 傻啊傻 2014-05-20 10:23:09. 链接： http://pan.baidu.com/s/1nt0VbIx · 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	1	0	0	0	3	2014-05-20 00:00:00	2014,05,23,删除,小组,29,17,楼主,21,20,14,13,04,登录,雪落,times,com,45
3075	2014-05-29 20:54:27.388658	http://www.douban.com/group/topic/52736528/	恋爱心理学终极来袭。 - 豆瓣	来自: 深海淘沙 2014-05-14 13:18:50. http://pan.baidu.com/s/1mgDhX5A 恋爱心理学 需要的朋友可以去我的朋友圈742715260. 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	1	0	0	0	3	2014-05-14 00:00:00	05,2014,删除,笨悦,小仙,16,18,17,22,19,楼主,10,15,14,13,12,20,21,01
3070	2014-05-29 20:54:27.346983	http://www.douban.com/group/topic/52135977/	分享给大家一个屏蔽优酷视频等视频广告的软件 - 豆瓣	... 也能屏蔽很多别的广告例如pps啊什么的,很不错啊,推荐给大家使用一下,到时候大家看视频啊电影什么的也方便~~下载地址:http://pan.baidu.com/s/1i3uWCKl 大家 ...	\N	1	0	0	0	3	2014-04-30 00:00:00	视频,广告,小组,屏蔽,粤语歌,...,登录,优酷,times,com,2014,喜欢,分享,软件,注册,推荐,一下
3069	2014-05-29 20:54:27.33864	http://www.douban.com/group/topic/52162458/	张建华：赫鲁晓夫的执政与改革 - 豆瓣	来自: 怪奇居士 2014-05-01 11:47:56. 赫鲁晓夫的执政与改革 讲者：张建华北师大教授 下载：http://pan.baidu.com/s/1gd7maR5 · 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	1	0	0	0	3	2014-05-01 00:00:00	小组,张建华,怪奇,登录,赫鲁晓夫,居士,讲座,times,com,2014,注册,执政,录音,改革,话题,六便士,汪晖,手机
3085	2014-05-29 20:54:27.64701	http://www.douban.com/group/topic/52518952/	精品300本清晰彩绘英文原版绘本，免费分享。 - 豆瓣	来自: 潘恩纳斯 2014-05-09 11:57:39. 链接: http://pan.baidu.com/s/1qWjTwsO 300本清晰英文原版绘本. 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	1	0	0	0	3	2014-05-09 00:00:00	05,2014,删除,15,19,16,18,12,20,13,14,10,11,胖楠楠,17,楼主,22,23,37
3083	2014-05-29 20:54:27.63049	http://www.douban.com/group/topic/52121766/	张建华：苏共20年代党内斗争与30年代“大清洗” - 豆瓣	来自: 怪奇居士 2014-04-30 11:16:34. 苏共20年代党内斗争与30年代“大清洗” 讲者：张建华北师大教授 下载：http://pan.baidu.com/s/1qWK0Mg0 · 喜欢 · 回应 推荐 ...	\N	1	0	0	0	3	2014-04-30 00:00:00	小组,30,张建华,怪奇,20,党内斗争,登录,苏共,年代,居士,讲座,清洗,times,com,2014,注册,录音,话题
3077	2014-05-29 20:54:27.405362	http://www.douban.com/group/topic/52404315/	看完视频，比较像033！！ - 豆瓣	我要进谷歌 2014-05-06 23:45:17. 球视频！ 球视频！ 五尺之徒 · http://pan.baidu.com/s/1qWtwHzA. 删除. 赞 回应 · 双乙反调 (中岛裕翔是正室，吉沢亮是新欢。) ...	\N	1	0	0	0	3	2014-05-06 00:00:00	2014,05,06,23,删除,李小璐,视频,07,033,00,小组,44,袁姗姗,不太像,45,截图,登录,一点
3087	2014-05-29 20:54:27.663719	http://www.douban.com/group/topic/52115808/	需要会计电算化软件和初级电算化操作视频的留邮箱 - 豆瓣	我的扣扣邮箱限制每天发50封，所以为了防止遗漏，请大家加我扣扣737537083 http://pan.baidu.com/share/home?uk=288509569&view=share#category/type=0.	\N	1	0	0	0	3	2014-04-29 00:00:00	电算化,小组,邮箱,登录,扣扣,会计,times,share,com,50,2014,分享,注册,初级,视频,考试,软件,注会
3084	2014-05-29 20:54:27.63867	http://www.douban.com/group/topic/52479699/	收集的各种小说，免费赠送，豆友请速来打包。 - 豆瓣	链接: http://pan.baidu.com/s/1c0zk5Vi 如果觉得可以的话，下载的朋友们可以帮助回下帖子吗？让更多的人可以下载，好东西就要大家分享。 喜欢 · 回应 推荐 喜欢 只 ...	\N	1	0	0	0	3	2014-05-08 00:00:00	小组,2014,登录,小说,豆友,times,com,05,注册,速来,打包,赠送,收集,免费,下载,商务英语,话题,抠门儿
3092	2014-05-29 20:54:27.705426	http://www.douban.com/group/topic/53357712/	你们要的金粉世家高清资源	来自: 谁 2014-05-29 12:40:02. http://pan.baidu.com/share/link?shareid=299756&uk=3204509438 密码0402. 14人 喜欢 喜欢 · 回应 推荐 喜欢 只看楼主 ...	\N	1	0	0	0	3	2014-05-29 12:54:26.851689	29,05,2014,删除,字幕,15,12,13,清晰,14,10,密码,楼主,小组,58,电视,在线播放,登录
3080	2014-05-29 20:54:27.447056	http://site.douban.com/119902/widget/notes/13912685/note/351372386/	景观雕塑：Circular Formations - 豆瓣	Michael Jantzen 设计，位于美国。项目多个八英尺直径的圆环组合而成，可作为雕塑摆放于公园中。 下载：http://dl.vmall.com/c04o3k28by 或http://pan.baidu.com/s/ ...	\N	1	0	0	0	3	2014-05-16 00:00:00	com,城市规划,雕塑,javascript,http,gt,Formations,Circular,2014,景观设计,浏览器,景观,雕塑公园,特伦,辛市,请换,我来,vmall,rights
3091	2014-05-29 20:54:27.697114	http://www.douban.com/group/topic/52695171/	心理学初级之催眠入门教程。 - 豆瓣	来自: 幸福导航123 2014-05-13 14:39:25. 链接: http://pan.baidu.com/s/1mg9ekNA 催眠教程之入门教程需要的朋友可以去我的朋友圈zyy0200. 喜欢 · 回应 推荐 喜欢 ...	\N	1	0	0	0	3	2014-05-13 00:00:00	小组,心理学,入门教程,登录,催眠,times,com,2014,注册,喜欢,初级,电子书籍,话题,朋友圈,手机,行摄,美胸,小蜗
3090	2014-05-29 20:54:27.688923	http://site.douban.com/119902/widget/notes/5123434/note/349985756/	北京新青海喜来登酒店 - 豆瓣	... 设有一个面积约1500平方米，最高高度约30米的酒店大堂，南向有三千余平米花园美景，成为酒店公共空间的核心。 下载PDF：http://pan.baidu.com/s/1jG1G5Rw.	\N	1	0	0	0	3	2014-05-09 00:00:00	酒店,喜来登,javascript,gt,com,2014,浏览器,建筑设计,建筑,办公,青海,北京,请换,我来,思凯来,rights,reserved,pan,layan
3081	2014-05-29 20:54:27.455365	http://www.douban.com/people/tam07/	南昌 - 豆瓣	... 老濕: 愛你~~~~ 01-02 19:35. 亚里我士多德呀: http://pan.baidu.com/share/link?shareid=665585644&uk=2718753079&fid=3608137869 顺便推荐这个po主的度 ...	\N	2	0	0	0	3	2014-05-01 00:00:00	middot,2013,gt,com,...,http,10,01,啊啊啊,douban,2012,20,相册,我来,www,people,amp,22
3072	2014-05-29 20:54:27.363696	http://www.douban.com/event/21663751/	北京英语角志愿者招募-望京中级学习小组招募分场助理_豆瓣	自我简介。申请表下载：http://pan.baidu.com/s/1ntFivd3 2. 手机号【组织者24小时之内会联系你。】 —————————————————————— 要求： 职责要求：	\N	1	0	0	0	3	2014-05-24 20:54:26.842144	英语角,学习,活动,小组,middot,分场,北京,QQ,组织者,中级,感兴趣,互助,英语,志愿者,公益,主持人,成员,com,00
3068	2014-05-29 20:54:27.33033	http://www.douban.com/group/topic/52404325/	傻逼多 - 豆瓣	球球你别说话 (焦虑) 2014-05-06 23:41:38. http://pan.baidu.com/s/1qWtwHzA. 删除. 赞 回应 · 只想睡懒觉 (放长线，钓只忠犬攻╮(￣▽￣)╭) 2014-05-06 23:47:05.	\N	1	0	0	0	3	2014-05-06 00:00:00	2014,05,23,06,小组,删除,球球,35,登录,焦虑,times,com,38,注册,说话,放长线,作文题目,话题
3063	2014-05-29 20:54:27.288516	http://movie.douban.com/subject/22993613/comments?sort=new_score	好想永远拥抱你！ 短评 - 豆瓣电影	0 有用 eien99 2013-10-30. http://pan.baidu.com/s/1FwszL. 0 有用 胡思乱想 2013-10-25. 看两个阿姨卖萌其实也很萌虽然觉得略狗血. 0 有用 静默有时 2013-10-14.	\N	0	0	0	0	3	2014-05-06 00:00:00	2013,10,浅野,2014,阿姨,温子,16,14,短评,电影,敢爱敢恨,拥抱,卖萌,优子,http,gt,com,31
3067	2014-05-29 20:54:27.321942	http://www.douban.com/group/topic/52559035/	【资源】 手帐手绘教程~~14本书哦~！！！ 有木有需... - 豆瓣	来自: 翟家佳 2014-05-10 10:43:39. 有需要的吗？？？ 希望大家能顶起来造福更多人哦 这是链接地址：http://pan.baidu.com/s/1ntuhMul · 2人 喜欢 喜欢 · 回应 推荐 ...	\N	1	0	0	0	3	2014-05-10 00:00:00	05,2014,删除,邻水,14,17,16,督查,20,15,19,22,13,12,10,21,18,11,楼主
3061	2014-05-29 20:54:27.271859	http://www.douban.com/group/topic/52121972/	张建华：访苏现象与外国人眼中的苏联 - 豆瓣	来自: 怪奇居士 2014-04-30 11:20:33. 访苏现象与外国人眼中的苏联——以罗曼罗兰和纪德等为例 讲者：张建华北师大 下载：http://pan.baidu.com/s/1o639RKY · 喜欢.	\N	1	0	0	0	3	2014-04-30 00:00:00	小组,张建华,访苏,怪奇,登录,居士,讲座,外国人,times,com,2014,眼中,注册,苏联,录音,现象,话题,六便士
3056	2014-05-29 20:54:27.230181	http://www.douban.com/group/topic/52585619/	时间差电子杂志期待你的到来 - 豆瓣	官方贴吧：时间差电子杂志吧 下载地址：【Vol.1】http://pan.baidu.com/s/1dDGHfep 【vol.2】http://pan.baidu.com/s/1ntFfsGL 【vol.3】http://pan.baidu.com/s/1EgTlW	\N	3	0	0	0	3	2014-05-10 00:00:00	时间差,com,文字,杂志,http,电子杂志,qq,廉恩,2014,10,心情,来稿,人生,美好,23,05,青春,岁月
3044	2014-05-29 20:54:27.13014	http://movie.douban.com/subject/25703430/discussion/56735655/	求DL - 豆瓣电影	2014-04-17 06:24:09 mgxshui. 悄悄：p a n 。 b a i d u 。com/s/1sjNMhPj 嘘，大家低调别声张。。。。 > 删除 · pigmoon. 2014-04-17 09:49:10 pigmoon (请拍掌).	\N	0	0	0	0	3	2014-05-08 00:00:00	gt,2014,删除,04,17,03,DL,13,mgxshui,21,xml,16,02,Zen,SSS,53,23,10,09
3039	2014-05-29 20:54:27.08843	http://movie.douban.com/subject/24522669/comments?sort=time	醒来吧，宝贝短评 - 豆瓣电影	0 有用 艾晨 2014-02-15. 果然很奇葩很诡异的实验电影。评论绝对两极化。http://pan.baidu.com/share/link?shareid=433678&uk=2785362661 ...	\N	0	0	0	0	3	2014-05-16 00:00:00	2014,15,02,2013,12,醒来,电影,宝贝,竣羽,我要,05,短评,gt,com,amp,198,16,04
3038	2014-05-29 20:54:27.080077	http://www.douban.com/group/topic/52648797/	+++分享【零基础轻松学习唱歌技巧】让世界充满美好... - 豆瓣	... 世界充满美好、温暖的乐章。 零基础学唱歌，让自己也有兴趣去感受音乐美好。 分享链接：http://pan.baidu.com/s/1mg5GsXi，. 可以留下QQ邮箱，急需的朋友加V信。	\N	1	0	0	0	3	2014-05-12 00:00:00	...,小组,美好,+++,摇滚,登录,唱歌,分享,充满,times,school,com,Old,2014,技巧,注册,轻松,音乐
3042	2014-05-29 20:54:27.113612	http://www.douban.com/group/topic/53056229/	葛兆光：纳“四裔”入“中华”-20世纪上半叶中国历... - 豆瓣	标题：葛兆光：纳“四裔”入“中华”-20世纪上半叶中国历史、考古、人类学家重建“中国”的努力. http://pan.baidu.com/s/1nt4qcHj · 喜欢 · 回应 推荐 喜欢 只看楼主. 你的回应.	\N	1	0	0	0	3	2014-05-21 00:00:00	小组,葛兆光,四裔,20,...,登录,上半叶,讲座,冤鬼,成神,怪奇,一匪,times,com,2014,注册,中华,居士
3030	2014-05-29 20:54:27.004689	http://www.douban.com/people/1452241/	Leann - 豆瓣	... 我也有好多粉的错觉 05-07 09:34. 黑色意志3: http://pan.baidu.com/s/1ntAuoXF#dir 福利比我上次发给你的书籍还要多有些重复我瞎逛无意间找到的 05-02 10:04 ...	\N	2	0	0	0	3	2014-05-25 20:54:26.821812	middot,Leann,05,gt,2014,...,com,运动,喜欢,女人,豆列,我来,http,12,10,健身,不算
3036	2014-05-29 20:54:27.063414	http://www.douban.com/group/topic/52329768/	中长线基金投资 - 豆瓣	... 定投，年收益20%，5万起投，可以分几年投，6-7年可以回本获利，期间还可以灵活提取，如果想详细了解，可以看下我们的计划书http://pan.baidu.com/s/1eQnBz3s	\N	1	0	0	0	3	2014-05-05 00:00:00	05,小组,2014,15,愿意,登录,等待,悦来,周小二,times,lily,http,com,Jenny,放长线钓大鱼,注册,人才,中长线
3018	2014-05-29 20:54:26.853046	http://www.douban.com/group/topic/52383302/	学摄影视频教程一共有128集，想要的豆友赶紧来吧 - 豆瓣	... 照片的技巧完全奉献！ 光说不练假把式，又说又练真把式 豆友需要的，+我微信；zyy0200 我慢慢会分享在朋友圈给大家！ 链接: http://pan.baidu.com/s/1o67DJAU.	\N	1	0	0	0	3	2014-05-06 00:00:00	摄影,小组,豆友,少艾,登录,视频教程,微信,times,com,2014,128,...,注册,教程,喜欢,一共,照片,雨景
3079	2014-05-29 20:54:27.438707	http://www.douban.com/group/topic/53056261/	葛兆光：“中国”的困境-从近世历史看“中国” - 豆瓣	来自: 一匪成神冤鬼哭 2014-05-21 18:04:11. http://pan.baidu.com/s/1dDvcVLJ · 喜欢 · 回应 推荐 喜欢 只看楼主. 你的回应. 回应请先登录 , 或注册. 推荐到广播.	\N	1	0	0	0	3	2014-05-21 00:00:00	小组,登录,讲座,冤鬼,葛兆光,成神,怪奇,一匪,times,com,2014,注册,近世,居士,历史,录音,困境,中国
\.


--
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xiang
--

SELECT pg_catalog.setval('posts_id_seq', 3092, true);


--
-- Data for Name: sites; Type: TABLE DATA; Schema: public; Owner: xiang
--

COPY sites (id, host, posts) FROM stdin;
1	bbs.hupu.com	0
2	tieba.baidu.com	0
3	douban.com	375
\.


--
-- Name: sites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xiang
--

SELECT pg_catalog.setval('sites_id_seq', 1, true);


--
-- Name: pans_link_key; Type: CONSTRAINT; Schema: public; Owner: xiang; Tablespace: 
--

ALTER TABLE ONLY pans
    ADD CONSTRAINT pans_link_key UNIQUE (link);


--
-- Name: pans_pkey; Type: CONSTRAINT; Schema: public; Owner: xiang; Tablespace: 
--

ALTER TABLE ONLY pans
    ADD CONSTRAINT pans_pkey PRIMARY KEY (id);


--
-- Name: post_pans_pkey; Type: CONSTRAINT; Schema: public; Owner: xiang; Tablespace: 
--

ALTER TABLE ONLY post_pans
    ADD CONSTRAINT post_pans_pkey PRIMARY KEY (post_id, pan_id);


--
-- Name: posts_link_key; Type: CONSTRAINT; Schema: public; Owner: xiang; Tablespace: 
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_link_key UNIQUE (link);


--
-- Name: posts_pkey; Type: CONSTRAINT; Schema: public; Owner: xiang; Tablespace: 
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: sites_host_key; Type: CONSTRAINT; Schema: public; Owner: xiang; Tablespace: 
--

ALTER TABLE ONLY sites
    ADD CONSTRAINT sites_host_key UNIQUE (host);


--
-- Name: sites_pkey; Type: CONSTRAINT; Schema: public; Owner: xiang; Tablespace: 
--

ALTER TABLE ONLY sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (id);


--
-- Name: on_post_pans_change; Type: TRIGGER; Schema: public; Owner: xiang
--

CREATE TRIGGER on_post_pans_change AFTER INSERT OR DELETE ON post_pans FOR EACH ROW EXECUTE PROCEDURE handle_post_pans_change();


--
-- Name: on_posts_change; Type: TRIGGER; Schema: public; Owner: xiang
--

CREATE TRIGGER on_posts_change AFTER INSERT OR DELETE ON posts FOR EACH ROW EXECUTE PROCEDURE handle_posts_change();


--
-- Name: post_pans_pan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xiang
--

ALTER TABLE ONLY post_pans
    ADD CONSTRAINT post_pans_pan_id_fkey FOREIGN KEY (pan_id) REFERENCES pans(id) ON DELETE RESTRICT;


--
-- Name: post_pans_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xiang
--

ALTER TABLE ONLY post_pans
    ADD CONSTRAINT post_pans_post_id_fkey FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE;


--
-- Name: posts_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xiang
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_site_id_fkey FOREIGN KEY (site_id) REFERENCES sites(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

