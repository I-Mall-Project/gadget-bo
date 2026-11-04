--
-- PostgreSQL database dump
--

\restrict yLIEAbyjDTdDXmsfhSLQexoKayo99ENWlHyeSaANTa8nbKFlptmJgZ62fiVDFtH

-- Dumped from database version 18.6 (ac70818)
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


--
-- Name: OrderSource; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."OrderSource" AS ENUM (
    'OFFLINE',
    'ONLINE'
);


--
-- Name: OrderStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."OrderStatus" AS ENUM (
    'PENDING',
    'SHIPPED',
    'DELIVERED',
    'RETURNED',
    'CANCELED'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Banner; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Banner" (
    id text NOT NULL,
    title text NOT NULL,
    subtitle text NOT NULL,
    image text NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    url text
);


--
-- Name: Brand; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Brand" (
    id text NOT NULL,
    name text NOT NULL,
    image text,
    slug text NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: Campaign; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Campaign" (
    id text NOT NULL,
    "userId" text NOT NULL,
    name text NOT NULL,
    image text DEFAULT 'images/campaign/campaign.png'::text,
    date timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP,
    slug text NOT NULL,
    "categoryId" text NOT NULL,
    "viewCount" integer DEFAULT 0,
    "createdBy" text,
    "updatedBy" text,
    "deletedBy" text,
    "isActive" boolean DEFAULT true NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: Category; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Category" (
    id text NOT NULL,
    "userId" text NOT NULL,
    name text NOT NULL,
    image text DEFAULT 'images/category/category.png'::text,
    slug text NOT NULL,
    "createdBy" text,
    "updatedBy" text,
    "deletedBy" text,
    "isActive" boolean DEFAULT true NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    discount double precision DEFAULT 0
);


--
-- Name: Contact; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Contact" (
    id text NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    subject text NOT NULL,
    message text NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: Coupon; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Coupon" (
    id text NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    "orderPriceLimit" double precision,
    "discountAmount" double precision NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: CustomerRiskProfile; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."CustomerRiskProfile" (
    id text NOT NULL,
    "phoneNumber" text NOT NULL,
    "totalOrders" integer DEFAULT 0 NOT NULL,
    "deliveredOrders" integer DEFAULT 0 NOT NULL,
    "returnedOrders" integer DEFAULT 0 NOT NULL,
    "successRate" double precision DEFAULT 100.0 NOT NULL,
    "isHighRisk" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: MasterProduct; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."MasterProduct" (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    "brandId" text,
    "categoryId" text NOT NULL,
    "subcategoryId" text,
    "subsubcategoryId" text,
    "priceUsd" double precision,
    rating double precision,
    "reviewCount" integer DEFAULT 0,
    "productSize" text,
    "usageFrequency" text,
    "skinType" text,
    "genderTarget" text,
    "packagingType" text,
    "mainIngredient" text,
    "crueltyFree" boolean,
    "countryOfOrigin" text,
    "imageUrl" text,
    "isActive" boolean DEFAULT true NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: Module; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Module" (
    id text NOT NULL,
    name text NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createdBy" text,
    "updatedBy" text,
    "deletedBy" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: Newsletter; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Newsletter" (
    id text NOT NULL,
    email text NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: Order; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Order" (
    id text NOT NULL,
    "userId" text,
    "couponId" text,
    "invoiceNumber" text,
    "customerName" text,
    "customerPhone" text,
    "customerAddress" text,
    "customerBillingAddress" text,
    "customerEmail" text,
    "customerCity" text,
    "customerPostalCode" text,
    "totalItems" double precision NOT NULL,
    "subtotalCost" double precision NOT NULL,
    subtotal double precision NOT NULL,
    "paymentMethod" text DEFAULT 'COD'::text,
    status public."OrderStatus" DEFAULT 'PENDING'::public."OrderStatus",
    otp text,
    "deliveryChargeInside" double precision,
    "deliveryChargeOutside" double precision,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createdBy" text,
    "updatedBy" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "senderPhoneNumber" text,
    "transactionId" text,
    "advancePaidAmount" double precision DEFAULT 0 NOT NULL,
    "dueAmount" double precision,
    "isPaymentVerified" boolean DEFAULT false NOT NULL,
    "orderSource" public."OrderSource" DEFAULT 'ONLINE'::public."OrderSource" NOT NULL
);


--
-- Name: OrderItem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."OrderItem" (
    id text NOT NULL,
    "orderId" text NOT NULL,
    "productId" text NOT NULL,
    "productAttributeId" text NOT NULL,
    name text NOT NULL,
    size text NOT NULL,
    "costPrice" double precision NOT NULL,
    "retailPrice" double precision NOT NULL,
    "discountPercent" double precision DEFAULT 0,
    "discountPrice" double precision DEFAULT 0,
    "discountedRetailPrice" double precision NOT NULL,
    quantity double precision NOT NULL,
    "totalCostPrice" double precision NOT NULL,
    "totalPrice" double precision NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createdBy" text,
    "updatedBy" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: Payment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Payment" (
    id text NOT NULL,
    "userId" text NOT NULL,
    date timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP,
    amount double precision DEFAULT 0 NOT NULL,
    due double precision DEFAULT 0,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createdBy" text,
    "updatedBy" text,
    "deletedBy" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: Preorder; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Preorder" (
    id text NOT NULL,
    "productId" text NOT NULL,
    "userId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "productAttributeId" text
);


--
-- Name: Product; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Product" (
    id text NOT NULL,
    "userId" text NOT NULL,
    "categoryId" text NOT NULL,
    "subcategoryId" text,
    "subsubcategoryId" text,
    "campaignId" text,
    "supplierId" text,
    "brandId" text,
    "productCode" text,
    barcode text,
    name text NOT NULL,
    "shortDescription" text,
    "longDescription" text,
    sku text,
    "isTrending" boolean DEFAULT false NOT NULL,
    "isFeatured" boolean DEFAULT false NOT NULL,
    "viewCount" integer DEFAULT 0,
    slug text NOT NULL,
    "createdBy" text,
    "updatedBy" text,
    "deletedBy" text,
    "isActive" boolean DEFAULT true NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "masterProductId" text,
    "sizeChartId" text
);


--
-- Name: ProductAttribute; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."ProductAttribute" (
    id text NOT NULL,
    "productId" text NOT NULL,
    size text NOT NULL,
    "costPrice" double precision NOT NULL,
    "retailPrice" double precision NOT NULL,
    "discountPercent" double precision DEFAULT 0,
    "discountPrice" double precision DEFAULT 0,
    "discountedRetailPrice" double precision NOT NULL,
    "stockAmount" double precision NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createdBy" text,
    "updatedBy" text,
    "deletedBy" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: ProductImage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."ProductImage" (
    id text NOT NULL,
    "productId" text NOT NULL,
    image text DEFAULT 'images/product/product.png'::text,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createdBy" text,
    "updatedBy" text,
    "deletedBy" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: Review; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Review" (
    id text NOT NULL,
    "productId" text NOT NULL,
    "userId" text NOT NULL,
    rating double precision NOT NULL,
    comment text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: Role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Role" (
    id text NOT NULL,
    name text NOT NULL,
    price double precision DEFAULT 0,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createdBy" text,
    "updatedBy" text,
    "deletedBy" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: RoleModule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."RoleModule" (
    id text NOT NULL,
    "roleId" text NOT NULL,
    "moduleId" text NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createdBy" text,
    "updatedBy" text,
    "deletedBy" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: SizeChart; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."SizeChart" (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    "categoryId" text,
    "subcategoryId" text,
    "subsubcategoryId" text,
    unit text DEFAULT 'inch'::text NOT NULL,
    columns jsonb NOT NULL,
    rows jsonb NOT NULL,
    note text,
    image text,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT now() NOT NULL
);


--
-- Name: Subcategory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Subcategory" (
    id text NOT NULL,
    "categoryId" text NOT NULL,
    name text NOT NULL,
    image text,
    slug text NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: Subsubcategory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Subsubcategory" (
    id text NOT NULL,
    "categoryId" text NOT NULL,
    "subcategoryId" text NOT NULL,
    name text NOT NULL,
    image text,
    slug text NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: Supplier; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Supplier" (
    id text NOT NULL,
    "userId" text NOT NULL,
    name text NOT NULL,
    address text NOT NULL,
    phone text NOT NULL,
    email text,
    "createdBy" text,
    "updatedBy" text,
    "deletedBy" text,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: User; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."User" (
    id text NOT NULL,
    "roleId" text,
    "parentId" text,
    name text NOT NULL,
    email text NOT NULL,
    phone text NOT NULL,
    address text,
    "billingAddress" text,
    country text,
    city text,
    "postalCode" text,
    image text DEFAULT 'images/user/user.png'::text,
    password text,
    otp integer,
    "otpCount" integer DEFAULT 0,
    "initialPaymentAmount" double precision DEFAULT 0,
    "initialPaymentDue" double precision DEFAULT 0,
    "installmentTime" double precision DEFAULT 0,
    "refreshToken" text,
    "isActive" boolean DEFAULT true NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createdBy" text,
    "updatedBy" text,
    "deletedBy" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: Wishlist; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Wishlist" (
    id text NOT NULL,
    "productId" text NOT NULL,
    "userId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: _ModuleToRole; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."_ModuleToRole" (
    "A" text NOT NULL,
    "B" text NOT NULL
);


--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


--
-- Data for Name: Banner; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Banner" (id, title, subtitle, image, "isActive", "createdAt", "updatedAt", url) FROM stdin;
3c5b3823-bf1c-4f2a-a9f6-a32aa1228498	//	///	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792793591/banner/jlrrgjnqtarqdd8r1duv.webp	t	2026-10-23 22:13:12.02	2026-10-23 22:13:12.02	///
\.


--
-- Data for Name: Brand; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Brand" (id, name, image, slug, "isActive", "createdAt", "updatedAt") FROM stdin;
5648e798-8bf2-4af1-826f-f1e3460c5cd0	new balance	https://res.cloudinary.com/dauivuma2/image/upload/v1759776199/brand/ptnz4iniktuowuoulcsw.webp	new-balance	t	2025-10-06 18:43:20.156	2025-10-06 18:43:20.156
58365a5e-02a4-4dbb-ad67-3dc92bde3b12	Adidas 	https://res.cloudinary.com/dauivuma2/image/upload/v1759776236/brand/hbkxyg7arcmgk52utz0i.webp	adidas	t	2025-09-10 23:28:29.717	2025-10-06 18:43:57.303
f3c8c570-59a8-430b-a02b-d6286f67f72d	Nike	https://res.cloudinary.com/dauivuma2/image/upload/v1759776283/brand/lc5tofcqvuxv3bzevedm.webp	nike	t	2025-09-10 23:28:13.065	2025-10-06 18:44:44.002
46f57871-64ef-44bb-af06-9b7791bf1db4	Jordan	https://res.cloudinary.com/dauivuma2/image/upload/v1759776292/brand/l2jwfs7jxozhmnqjcbga.webp	jordan	t	2025-09-06 20:55:35.666	2025-10-06 18:44:53.277
261c2f91-cfa7-45f9-8af6-dd374c40a318	IMPORTED BAGS	\N	imported-bags	t	2026-04-20 10:54:47.979	2026-04-20 10:54:47.979
dab7e547-9875-467c-a9cb-22bf3f1def7d	PUMA	\N	puma	t	2026-06-09 22:52:38.115	2026-06-09 22:52:38.115
a9e93976-cee0-48aa-baa3-ada3c09c1798	LV	\N	lv	t	2026-06-09 22:52:49.201	2026-06-09 22:52:49.201
205018ab-e806-4419-9a8d-063ac8056893	Drunk Elephant	\N	drunk-elephant	t	2026-08-13 18:14:01.724	2026-08-13 18:14:01.724
66f571ee-9cdc-4d35-8918-730de07aebb4	Laura Mercier	\N	laura-mercier	t	2026-08-13 18:14:07.852	2026-08-13 18:14:07.852
ba9b470d-ee60-4332-8787-49f439e210db	Natasha Denona	\N	natasha-denona	t	2026-08-13 18:14:11.77	2026-08-13 18:14:11.77
13de784c-e8e7-4630-8ec7-53888eea45c3	Ilia Beauty	\N	ilia-beauty	t	2026-08-13 18:14:16.01	2026-08-13 18:14:16.01
3bc04437-21b4-4de0-b5f1-f9ece4cf8767	Charlotte Tilbury	\N	charlotte-tilbury	t	2026-08-13 18:14:19.946	2026-08-13 18:14:19.946
b6a8fad3-0983-4336-82fd-576effcd1392	Danessa Myricks	\N	danessa-myricks	t	2026-08-13 18:14:22.655	2026-08-13 18:14:22.655
0b13b021-529e-4cd8-b216-4c54e4757363	Bourjois	\N	bourjois	t	2026-08-13 18:14:26.583	2026-08-13 18:14:26.583
b9fb9588-9686-409c-bf56-d15c6b985342	IT Cosmetics	\N	it-cosmetics	t	2026-08-13 18:14:33.507	2026-08-13 18:14:33.507
f5e629a7-55ca-4954-b3e7-6f860b18648c	Fenty Beauty	\N	fenty-beauty	t	2026-08-13 18:14:37.415	2026-08-13 18:14:37.415
077cf081-bcbc-4b76-a22b-2536677e86b2	Sisley	\N	sisley	t	2026-08-13 18:14:40.122	2026-08-13 18:14:40.122
2b4c71d7-7295-46b2-80b6-57896a6905d0	Juviaâs Place	\N	juvias-place	t	2026-08-13 18:14:42.831	2026-08-13 18:14:42.831
b7865c9c-ba37-4381-b3d6-182492ee7aa5	NARS	\N	nars	t	2026-08-13 18:14:47.037	2026-08-13 18:14:47.037
29a22280-3559-41c2-8ae3-4f94b9c8649f	ColourPop	\N	colourpop	t	2026-08-13 18:14:50.938	2026-08-13 18:14:50.938
243d8a1e-8d56-46cb-a3d7-ab17eba0594f	Huda Beauty	\N	huda-beauty	t	2026-08-13 18:14:54.849	2026-08-13 18:14:54.849
6adf3039-f180-41cf-a712-2e9d64376532	Tatcha	\N	tatcha	t	2026-08-13 18:14:58.75	2026-08-13 18:14:58.75
8e2bb2b5-9480-4b9e-be42-8db2ee5d76f1	Kiehlâs	\N	kiehls	t	2026-08-13 18:15:02.978	2026-08-13 18:15:02.978
586ff1ab-d50f-4557-9699-f5bdd27f2f41	Tarte	\N	tarte	t	2026-08-13 18:15:09.603	2026-08-13 18:15:09.603
22f62401-24cf-4df1-a371-c26ec977f618	Glossier	\N	glossier	t	2026-08-13 18:15:13.505	2026-08-13 18:15:13.505
27161484-2b68-4525-9c64-297f88ace4fe	Make Up For Ever	\N	make-up-for-ever	t	2026-08-13 18:15:17.416	2026-08-13 18:15:17.416
92899931-906e-412d-8281-46cb8786a78d	Anastasia Beverly Hills	\N	anastasia-beverly-hills	t	2026-08-13 18:15:21.621	2026-08-13 18:15:21.621
c7b24553-948c-43d5-9061-53d30c4c6389	E.l.f.	\N	elf	t	2026-08-13 18:15:27.035	2026-08-13 18:15:27.035
a611419a-3158-4816-b2d8-ffbe445e2176	Hourglass	\N	hourglass	t	2026-08-13 18:15:29.748	2026-08-13 18:15:29.748
82011e58-8504-4e58-bc44-efeab1c06a6d	Pat McGrath Labs	\N	pat-mcgrath-labs	t	2026-08-13 18:15:32.454	2026-08-13 18:15:32.454
35dd1abe-cf34-441d-b775-1744382f2a97	Too Faced	\N	too-faced	t	2026-08-13 18:15:36.962	2026-08-13 18:15:36.962
8b2262c7-c95c-4320-af08-dd73fbe7eb95	Perricone MD	\N	perricone-md	t	2026-08-13 18:15:39.668	2026-08-13 18:15:39.668
4ec90758-28df-4c66-b477-3b86d389dbb0	RMS Beauty	\N	rms-beauty	t	2026-08-13 18:15:42.367	2026-08-13 18:15:42.367
0d996b48-7a11-4367-b5ea-dc81f317585e	Urban Decay	\N	urban-decay	t	2026-08-13 18:15:49.588	2026-08-13 18:15:49.588
2ee5f762-c23d-4570-bf28-0d3009178388	Rare Beauty	\N	rare-beauty	t	2026-08-13 18:15:52.581	2026-08-13 18:15:52.581
0d851455-8510-4bd2-9132-7f40397e4444	Becca	\N	becca	t	2026-08-13 18:15:58.271	2026-08-13 18:15:58.271
3028198d-dca9-4cf5-8f0b-fc364d936db5	Patrick Ta	\N	patrick-ta	t	2026-08-13 18:16:00.965	2026-08-13 18:16:00.965
73ea470a-885b-49f0-81d0-7b403aa032aa	Shiseido	\N	shiseido	t	2026-08-13 18:16:03.662	2026-08-13 18:16:03.662
ebe05b3a-7d63-4bce-9350-74b9747990d6	Kylie Cosmetics	\N	kylie-cosmetics	t	2026-08-13 18:16:08.152	2026-08-13 18:16:08.152
e6969654-32a9-48ab-bade-2cfa7c1519af	Bite Beauty	\N	bite-beauty	t	2026-08-13 18:16:16.557	2026-08-13 18:16:16.557
b8c3921a-9475-4fc0-bbfe-d767c81d55af	Yves Saint Laurent	\N	yves-saint-laurent	t	2026-08-13 18:16:41.774	2026-08-13 18:16:41.774
e20b076d-6211-4010-b51d-0cd618f9506f	Bobby Brown	\N	bobby-brown	t	2026-08-13 18:16:58.023	2026-08-13 18:16:58.023
23a953a7-1e65-4df3-b801-9aee50aa230c	Farsali	\N	farsali	t	2026-08-13 18:17:02.248	2026-08-13 18:17:02.248
e17cc623-9dab-4143-a057-10595a69b153	Morphe	\N	morphe	t	2026-08-13 18:17:09.793	2026-08-13 18:17:09.793
3e7b4099-71e9-4e1d-aa0d-9d709167353e	Milk Makeup	\N	milk-makeup	t	2026-08-13 18:17:33.836	2026-08-13 18:17:33.836
f353aad8-e590-45c3-9e4e-909aef2350f2	Clinique	\N	clinique	t	2026-08-13 18:17:38.055	2026-08-13 18:17:38.055
7ed3b6fa-ff00-4635-b160-2fb8e3e26895	KVD Beauty	\N	kvd-beauty	t	2026-08-13 18:17:45.273	2026-08-13 18:17:45.273
\.


--
-- Data for Name: Campaign; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Campaign" (id, "userId", name, image, date, slug, "categoryId", "viewCount", "createdBy", "updatedBy", "deletedBy", "isActive", "isDeleted", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Category; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Category" (id, "userId", name, image, slug, "createdBy", "updatedBy", "deletedBy", "isActive", "isDeleted", "createdAt", "updatedAt", discount) FROM stdin;
1c1a7e41-567e-4b29-9b5c-ea56cd707cdd	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	Jersy	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792794519/category/bo7jtyohoxnno99cgnoj.webp	clothingbrandstrike-jersy	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	t	t	2026-10-23 22:27:48.421	2026-10-23 22:29:19.239	0
39a623bc-9948-45c9-935d-7f104dd61593	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	Jersy	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792794689/category/utxlrmeei0bukxr1iukt.webp	clothingbrandstrike-jersy	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	t	f	2026-10-23 22:31:21.486	2026-10-23 22:31:29.766	0
3ac5afc3-0ed6-4691-8fd4-a6f0ee161c60	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	Women	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792793746/category/mwoasrtkqzbylkrvlqqz.webp	clothingbrandstrike-women	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	t	t	2026-10-23 22:15:39.234	2026-10-23 22:20:39.555	0
461fbcba-4cea-4602-8756-d167170e221d	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	Men	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792793565/category/zbr8wnei8sefgn8vvsu4.webp	clothingbrandstrike-men	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	t	t	2026-10-23 21:57:08.391	2026-10-23 22:20:43.571	0
74342a43-b564-48b4-9b33-18c51aa6e213	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	Newborn	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792794715/category/tm7lv3ocuvh9erba4xmw.webp	clothingbrandstrike-newborn	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	t	f	2026-10-23 22:31:45.881	2026-10-23 22:31:56.505	0
1d565b94-3d41-4232-b58b-bb06ab78bdf5	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	Kids	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792794733/category/jfa4vqxoufglkhg1n0f2.webp	clothingbrandstrike-kids	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	t	f	2026-10-23 22:32:05.985	2026-10-23 22:32:13.613	0
c9a87de0-bce7-42ec-abb3-e8cdf407183e	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	Accessories	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792794756/category/vv2g5zhyyki1gu204lhv.webp	clothingbrandstrike-accessories	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	t	f	2026-10-23 22:32:27.9	2026-10-23 22:32:36.904	0
9b505b3a-8549-4883-80f9-283153bc8915	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	 Home & Gift	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792794414/category/ywehfb4zrthzupmullap.webp	clothingbrandstrike-home-gift	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	t	t	2026-10-23 22:25:53.55	2026-10-23 22:29:23.576	0
4528890e-4a4f-4459-8526-6e49a86404b8	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	 Men	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792794298/category/bxlg3uq4xpn53ynhwuds.webp	clothingbrandstrike-men	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	t	t	2026-10-23 22:24:11.016	2026-10-23 22:30:19.275	0
6486aba1-7d05-45a9-9de4-dafc6b3e7e1e	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	 Women	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792794241/category/ktts3p6tf79fibozkku5.webp	clothingbrandstrike-women	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	t	t	2026-10-23 22:23:53.476	2026-10-23 22:30:22.515	0
1eae32fa-e444-4100-8f88-991ae675cfe3	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	 Accesories	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792794221/category/yx32eteky6ei5hp8jubc.webp	clothingbrandstrike-accesories	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	t	t	2026-10-23 22:23:25.201	2026-10-23 22:30:25.37	0
e1a9b0a7-6287-4474-ae4c-ef137738468a	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	Footwear	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792794132/category/azeu5fodxzyfugwpoaqu.webp	clothingbrandstrike-footwear	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	t	t	2026-10-23 22:22:04.77	2026-10-23 22:30:28.244	0
5a07d915-eeb1-4b0e-8de3-553d13978e0b	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	Newborn	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792794050/category/nvdtzoggplyjgkhqb0wr.webp	clothingbrandstrike-newborn	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	t	t	2026-10-23 22:20:32.945	2026-10-23 22:30:31.215	0
33c56a8b-7ab0-484c-95f8-d215d3e811a4	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	Kids	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792793833/category/evaf5uievtajk0mhhzua.webp	clothingbrandstrike-kids	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	t	t	2026-10-23 22:17:04.237	2026-10-23 22:30:34.039	0
a1e108b2-5ad2-4e81-93e6-cb15b278ecec	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	Home & Gift	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792794671/category/zuvk4qchpx8huhgupyo6.webp	clothingbrandstrike-home-gift	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	t	f	2026-10-23 22:31:01.393	2026-10-23 22:31:11.986	0
204873a3-bdff-478c-bd70-8cd370df47f4	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	Footwear	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792794775/category/jsvzbiukd0qwohptwx00.webp	clothingbrandstrike-footwear	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	t	f	2026-10-23 22:32:47.939	2026-10-23 22:32:55.921	0
b09305fb-3470-4f62-a4a9-576813e3fb8d	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	Women	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792794795/category/hk7btphjudbhnvctjpsx.webp	clothingbrandstrike-women	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	t	f	2026-10-23 22:33:07.472	2026-10-23 22:33:15.778	0
5d9071c7-aa35-4165-83b1-b8a6468ad556	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	Men	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792794811/category/bwsbmzohxriwihswxepz.webp	clothingbrandstrike-men	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	t	f	2026-10-23 22:33:23.753	2026-10-24 09:37:14.336	10
\.


--
-- Data for Name: Contact; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Contact" (id, name, email, subject, message, "isActive", "createdAt", "updatedAt") FROM stdin;
68f97385-2188-4997-9587-d63502a26a3d	Chris K.	pat@aneesho.com	design work	Do you need help with graphic design - brochures, banners, flyers, advertisements, social media posts, logos etc.?\n\nWe charge a low fixed monthly fee. Let me know if you're interested and would like to see our portfolio.	t	2025-03-20 09:17:40.418	2025-03-20 09:17:40.418
9d5d30a7-4c7c-4c45-99ad-434178a7a784	Chris K.	pat@aneesho.com	design wqork	https://www.funmajnu.com/contact	t	2025-03-20 13:16:58.62	2025-03-20 13:16:58.62
959aadad-8d94-45f0-9b2f-352f789ee393	Chris K.	pat@aneesho.com	design work	Do you need help with graphic design - brochures, banners, flyers, advertisements, social media posts, logos etc.?\n\nWe charge a low fixed monthly fee. Let me know if you're interested and would like to see our portfolio.	t	2025-03-21 05:11:15.664	2025-03-21 05:11:15.664
be2ef180-e9dd-456f-b175-9874b919c849	Shamim	shamimrahman920@gmail.com	Strike	Qualityful product	t	2025-08-12 19:31:58.691	2025-08-12 19:31:58.691
c662f507-9930-47d4-922b-890f73a09551	Md. Shamim Rahman	shamimrahman920@gmail.com	complain	slow	t	2026-08-25 20:43:02.514	2026-08-25 20:43:02.514
\.


--
-- Data for Name: Coupon; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Coupon" (id, code, name, "orderPriceLimit", "discountAmount", "isActive", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: CustomerRiskProfile; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."CustomerRiskProfile" (id, "phoneNumber", "totalOrders", "deliveredOrders", "returnedOrders", "successRate", "isHighRisk", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: MasterProduct; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."MasterProduct" (id, name, "brandId", "categoryId", "subcategoryId", "subsubcategoryId", "priceUsd", rating, "reviewCount", "productSize", "usageFrequency", "skinType", "genderTarget", "packagingType", "mainIngredient", "crueltyFree", "countryOfOrigin", "imageUrl", "isActive", "isDeleted", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Module; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Module" (id, name, "isDeleted", "createdBy", "updatedBy", "deletedBy", "createdAt", "updatedAt") FROM stdin;
fc81a5e1-444d-47ec-aefc-821a7c4926db	role-create	f	\N	\N	\N	2025-02-08 20:25:54.4	2025-02-08 20:25:54.4
df0324f1-726c-4b88-b647-740112f81af3	role-list	f	\N	\N	\N	2025-02-08 20:25:55.31	2025-02-08 20:25:55.31
33aff310-5bdc-44fb-b70c-6bfa0eb1c44e	role-user-list	f	\N	\N	\N	2025-02-08 20:25:55.727	2025-02-08 20:25:55.727
20b00bcd-abef-4f42-b4bd-f9f87c3b459b	role-single	f	\N	\N	\N	2025-02-08 20:25:56.243	2025-02-08 20:25:56.243
ab236e0a-e177-47bc-996e-7957f5f74024	role-edit	f	\N	\N	\N	2025-02-08 20:25:56.656	2025-02-08 20:25:56.656
45b87d20-7698-47f6-b06e-d54b0a21447a	role-remove	f	\N	\N	\N	2025-02-08 20:25:57.157	2025-02-08 20:25:57.157
5bbc149a-cf58-4cf1-bede-e83a70ba04e0	module-create	f	\N	\N	\N	2025-02-08 20:25:57.583	2025-02-08 20:25:57.583
745e873c-f2c6-4dca-8468-ac6097aac834	module-list	f	\N	\N	\N	2025-02-08 20:25:57.978	2025-02-08 20:25:57.978
884afff8-2321-4a70-bb55-8c1daea5f323	module-user-list	f	\N	\N	\N	2025-02-08 20:25:58.5	2025-02-08 20:25:58.5
a0f80dce-b64f-4f74-9f2e-03875b907890	module-single	f	\N	\N	\N	2025-02-08 20:25:59.006	2025-02-08 20:25:59.006
75fe294f-8426-4f59-8e6e-0b006883b592	module-edit	f	\N	\N	\N	2025-02-08 20:25:59.399	2025-02-08 20:25:59.399
256fb7e5-145d-44b5-a372-c8cb87f084da	module-remove	f	\N	\N	\N	2025-02-08 20:25:59.823	2025-02-08 20:25:59.823
42311836-00d8-46a5-99c0-ad0e0f552a0f	user-create	f	\N	\N	\N	2025-02-08 20:26:00.297	2025-02-08 20:26:00.297
81c49ff4-d4da-4088-b250-b5b658c65e12	user-list	f	\N	\N	\N	2025-02-08 20:26:00.748	2025-02-08 20:26:00.748
85b92126-f6b7-4964-a411-556d3acfb309	user-user-list	f	\N	\N	\N	2025-02-08 20:26:01.156	2025-02-08 20:26:01.156
92a1b8e3-3004-4d68-85e1-209fd8876114	user-single	f	\N	\N	\N	2025-02-08 20:26:01.565	2025-02-08 20:26:01.565
80d2ab31-cb37-4565-9e41-b8842fe7994b	user-edit	f	\N	\N	\N	2025-02-08 20:26:01.974	2025-02-08 20:26:01.974
84ad5fe7-6d06-45c8-968c-3b5125efd4e9	user-ban	f	\N	\N	\N	2025-02-08 20:26:02.385	2025-02-08 20:26:02.385
fc92d13b-bf35-40a5-8c05-7713b9cacd3c	user-remove	f	\N	\N	\N	2025-02-08 20:26:02.898	2025-02-08 20:26:02.898
a9593357-c239-4147-a1bc-a3b99c728e25	monthly-payment-create	f	\N	\N	\N	2025-02-08 20:26:03.309	2025-02-08 20:26:03.309
3caa8d0d-c25c-464b-b9ad-0103afd9d5a3	monthly-payment-list	f	\N	\N	\N	2025-02-08 20:26:04.127	2025-02-08 20:26:04.127
5b31611c-76df-4188-bdca-ee4fa0f6aaf4	monthly-payment-user-list	f	\N	\N	\N	2025-02-08 20:26:04.724	2025-02-08 20:26:04.724
e53ecf48-8ebb-4e39-a1ce-033c8830b130	monthly-payment-single	f	\N	\N	\N	2025-02-08 20:26:05.178	2025-02-08 20:26:05.178
a3133e01-b9c6-4dc2-b462-dd79e4347117	monthly-payment-edit	f	\N	\N	\N	2025-02-08 20:26:05.69	2025-02-08 20:26:05.69
1fd5bd5f-3b68-443e-86e4-021ba0a07328	monthly-payment-remove	f	\N	\N	\N	2025-02-08 20:26:06.177	2025-02-08 20:26:06.177
b94673dc-2475-4c59-819a-90a86d52b1e9	category-create	f	\N	\N	\N	2025-02-08 20:26:06.686	2025-02-08 20:26:06.686
3f3d745c-a6ba-4d2c-a8ca-d2582733b602	category-list	f	\N	\N	\N	2025-02-08 20:26:07.199	2025-02-08 20:26:07.199
0187fdc4-8580-4179-9271-c4724abaf273	category-user-list	f	\N	\N	\N	2025-02-08 20:26:08.007	2025-02-08 20:26:08.007
7eaada76-2ef6-4f85-ab58-837ac9b736fc	category-single	f	\N	\N	\N	2025-02-08 20:26:08.523	2025-02-08 20:26:08.523
16732b8e-9b64-4afc-9ed3-e0f474612031	category-edit	f	\N	\N	\N	2025-02-08 20:26:09.45	2025-02-08 20:26:09.45
d9679ae5-4624-48e2-9d52-35d7a97c159a	category-ban	f	\N	\N	\N	2025-02-08 20:26:09.957	2025-02-08 20:26:09.957
132d7341-cf18-4da4-a326-63b5971d0c5c	category-remove	f	\N	\N	\N	2025-02-08 20:26:10.801	2025-02-08 20:26:10.801
e237aab8-8107-4e4e-8010-aadff5871207	campaign-create	f	\N	\N	\N	2025-02-08 20:26:11.397	2025-02-08 20:26:11.397
5575cce7-f5d9-467f-a8ee-86d35bcfff69	campaign-list	f	\N	\N	\N	2025-02-08 20:26:12.009	2025-02-08 20:26:12.009
231f02a4-fa63-4441-a263-94814f6bef82	campaign-user-list	f	\N	\N	\N	2025-02-08 20:26:12.421	2025-02-08 20:26:12.421
2f199e3d-00fe-4814-9f5a-fe26a1475e26	campaign-single	f	\N	\N	\N	2025-02-08 20:26:12.941	2025-02-08 20:26:12.941
de0394b7-c52e-4217-86a7-10430c548cc5	campaign-edit	f	\N	\N	\N	2025-02-08 20:26:13.423	2025-02-08 20:26:13.423
3d914d10-b3f5-4681-bba7-1ec84c655e0f	campaign-ban	f	\N	\N	\N	2025-02-08 20:26:13.863	2025-02-08 20:26:13.863
f8c8777e-530b-47f9-9452-17531553bf78	campaign-remove	f	\N	\N	\N	2025-02-08 20:26:14.467	2025-02-08 20:26:14.467
ca8dfe5e-224a-4be0-b175-48852bac8e99	product-create	f	\N	\N	\N	2025-02-08 20:26:15.305	2025-02-08 20:26:15.305
2254823e-4e85-4602-b524-9649ef1720dd	product-list	f	\N	\N	\N	2025-02-08 20:26:16.225	2025-02-08 20:26:16.225
a1f9e476-dec3-4f58-9ca3-a65e9e1b2391	product-user-list	f	\N	\N	\N	2025-02-08 20:26:17.111	2025-02-08 20:26:17.111
36bcbed8-8f34-4b1b-b4ff-cdbdd6530fea	product-single	f	\N	\N	\N	2025-02-08 20:26:17.703	2025-02-08 20:26:17.703
07f2abfe-0183-4cce-bdd0-7a6f81efd35a	product-edit	f	\N	\N	\N	2025-02-08 20:26:18.256	2025-02-08 20:26:18.256
f53cf660-3b69-483c-b5d5-59ed41a5dd8a	product-ban	f	\N	\N	\N	2025-02-08 20:26:18.665	2025-02-08 20:26:18.665
09f0168b-0e84-4e40-b8ab-377ea5bea82a	product-remove	f	\N	\N	\N	2025-02-08 20:26:19.359	2025-02-08 20:26:19.359
e56fb295-2b3d-49b3-b854-36174fc913ed	supplier-create	f	\N	\N	\N	2025-02-08 20:26:19.796	2025-02-08 20:26:19.796
5fc32cb5-ad77-46d6-a025-428db7b2dfc9	supplier-list	f	\N	\N	\N	2025-02-08 20:26:20.301	2025-02-08 20:26:20.301
1322bda1-786f-437b-aed4-990a3c8e6cd7	supplier-user-list	f	\N	\N	\N	2025-02-08 20:26:20.677	2025-02-08 20:26:20.677
38dd1aa4-8333-4d45-b171-6729855eb4c7	supplier-single	f	\N	\N	\N	2025-02-08 20:26:21.128	2025-02-08 20:26:21.128
065089f3-e5f0-4487-949f-4f133e826484	supplier-edit	f	\N	\N	\N	2025-02-08 20:26:21.741	2025-02-08 20:26:21.741
8f002ef7-953b-4a40-92cc-7765c2d6a234	supplier-ban	f	\N	\N	\N	2025-02-08 20:26:22.149	2025-02-08 20:26:22.149
6cc44e1b-1788-4906-8fdf-27bfc2482452	supplier-remove	f	\N	\N	\N	2025-02-08 20:26:22.772	2025-02-08 20:26:22.772
528b9a1f-efa4-430a-8f1b-37dfff7b3a73	order-create	f	\N	\N	\N	2025-02-08 20:26:23.378	2025-02-08 20:26:23.378
8f0a4b43-2b2c-445a-9458-f0293efd590d	dashboard-campaign-total	f	\N	\N	\N	2025-02-08 20:26:23.788	2025-02-08 20:26:23.788
73f9a996-fd1b-4425-9075-cda154141dde	dashboard-category-total	f	\N	\N	\N	2025-02-08 20:26:24.198	2025-02-08 20:26:24.198
cc698257-10f4-4eca-a1ad-7a390a8b164d	dashboard-product-total	f	\N	\N	\N	2025-02-08 20:26:24.608	2025-02-08 20:26:24.608
b8eaa65e-594a-4e19-9513-09534363f29c	dashboard-order-total	f	\N	\N	\N	2025-02-08 20:26:25.016	2025-02-08 20:26:25.016
fd9499da-e2f4-479c-8dd1-d76c69c87dde	dashboard-order-status-total	f	\N	\N	\N	2025-02-08 20:26:25.425	2025-02-08 20:26:25.425
f015ea7a-64d8-4e6c-95da-b753da906250	dashboard-revenue-total	f	\N	\N	\N	2025-02-08 20:26:25.836	2025-02-08 20:26:25.836
e371d17f-3da7-42a6-84cd-9a4a7e9768bb	customer	f	\N	\N	\N	2025-02-08 20:26:26.244	2025-02-08 20:26:26.244
\.


--
-- Data for Name: Newsletter; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Newsletter" (id, email, "isActive", "createdAt", "updatedAt") FROM stdin;
420045dc-9431-429b-92a6-947e327c4d27	shamimrahman920@gmail.com	t	2025-02-21 19:00:17.97	2025-02-21 19:00:17.97
e83acd29-8d52-435a-a7a4-4bf673f56a7c	ekram.eshan9090@gmail.com	t	2025-02-22 08:02:24.945	2025-02-22 08:02:24.945
c8116291-e3eb-4852-be67-0e795a67893d	suhrid671@gmail.com	t	2025-06-25 03:40:04.804	2025-06-25 03:40:04.804
4ab2cecd-f2b6-4abd-b8e8-768a205cc39c	jarrarkarim@gmail.com	t	2025-06-26 14:11:14.665	2025-06-26 14:11:14.665
c9a4084f-8d2e-49ab-8067-239285cf29d6	shamimrocky801@yahoo.com	t	2025-08-28 05:19:17.981	2025-08-28 05:19:17.981
f6cfc26f-a95d-4f76-8877-756e5f2aa55c	itzsakib034@gmail.com	t	2026-01-21 14:33:10.509	2026-01-21 14:33:10.509
3a1eb5dd-3b97-4740-874b-aa52a5835e60	mehjabinayesha5@gmail.com	t	2026-01-27 10:20:38.155	2026-01-27 10:20:38.155
d4d0bab5-d2f2-489a-87f7-88c0ea40250e	astatinealtasbinnomann@gmail.com	t	2026-02-23 17:26:55.023	2026-02-23 17:26:55.023
b9291cfd-d820-488f-9a34-c2e01f6f9906	tareq332@gmail.com	t	2026-03-14 16:48:03.699	2026-03-14 16:48:03.699
5251a963-202b-499b-ae19-1307d20f0b87	mejbashamim2@gmail.com	t	2026-05-18 20:57:33.148	2026-05-18 20:57:33.148
f5300688-d476-460c-a7bd-929aaedbdd87	sf@gmail.com	t	2026-08-21 21:14:08.032	2026-08-21 21:14:08.032
\.


--
-- Data for Name: Order; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Order" (id, "userId", "couponId", "invoiceNumber", "customerName", "customerPhone", "customerAddress", "customerBillingAddress", "customerEmail", "customerCity", "customerPostalCode", "totalItems", "subtotalCost", subtotal, "paymentMethod", status, otp, "deliveryChargeInside", "deliveryChargeOutside", "isDeleted", "createdBy", "updatedBy", "createdAt", "updatedAt", "senderPhoneNumber", "transactionId", "advancePaidAmount", "dueAmount", "isPaymentVerified", "orderSource") FROM stdin;
a100cfb7-0600-4ef7-9b7e-7657858a99e6	04919902-1fd3-43e4-b8b7-263543b9f6fa	\N	4020990	Deepta Barua	01775172680	Dhaka	Dhaka	deepta.barua@northsouth.edu	Dhaka	1212	1	2200	2570	Cash on Delivery	PENDING	\N	100	\N	f	\N	\N	2025-02-17 16:07:07.611	2025-02-17 16:07:07.611	\N	\N	0	\N	f	ONLINE
a7699e0c-925b-4446-9226-38f8bb61d6ec	04919902-1fd3-43e4-b8b7-263543b9f6fa	\N	1147680	Deepta Barua	01775172680	Dhaka	Dhaka	deepta.barua@northsouth.edu	Dhaka	1212	1	2200	2570	Cash on Delivery	PENDING	\N	100	\N	f	\N	\N	2025-02-17 16:18:54.873	2025-02-17 16:18:54.873	\N	\N	0	\N	f	ONLINE
373fe0d2-54d7-4630-8334-b7812f43cf73	04919902-1fd3-43e4-b8b7-263543b9f6fa	\N	0728480	Deepta Barua	01775172680	Dhaka	Dhaka	deepta.barua@northsouth.edu	Dhaka	1212	1	2200	2570	Cash on Delivery	PENDING	\N	100	\N	f	\N	\N	2025-02-17 16:34:46.301	2025-02-17 16:34:46.301	\N	\N	0	\N	f	ONLINE
e6280768-cf3b-415c-a976-8fbe163076f5	04919902-1fd3-43e4-b8b7-263543b9f6fa	\N	7854700	Deepta Barua	01775172680	Dhaka	Dhaka	deepta.barua@northsouth.edu	Dhaka	1212	1	2200	2570	Cash on Delivery	PENDING	\N	100	\N	f	\N	\N	2025-02-20 17:33:18.592	2025-02-20 17:33:18.592	\N	\N	0	\N	f	ONLINE
b4395a28-f625-4829-a04e-55b0e577f365	04919902-1fd3-43e4-b8b7-263543b9f6fa	\N	9160931	Deepta Barua	01775172680	Dhaka	Dhaka	deepta.barua@northsouth.edu	Dhaka	1212	1	2200	2570	Cash on Delivery	PENDING	\N	100	\N	f	\N	\N	2025-02-20 17:35:29.808	2025-02-20 17:35:29.808	\N	\N	0	\N	f	ONLINE
b089d578-150a-4317-8453-cfc958da4798	04919902-1fd3-43e4-b8b7-263543b9f6fa	\N	5996780	Deepta Barua	01775172680	Dhaka	Dhaka	deepta.barua@northsouth.edu	Dhaka	1212	1	2200	2570	Cash on Delivery	PENDING	\N	100	\N	f	\N	\N	2025-02-20 18:03:29.529	2025-02-20 18:03:29.529	\N	\N	0	\N	f	ONLINE
d5ab1da9-4956-4e74-9f09-f6948a022371	04919902-1fd3-43e4-b8b7-263543b9f6fa	\N	7523121	Deepta Barua	01775172680	Dhaka	Dhaka	deepta.barua@northsouth.edu	Dhaka	1212	1	2200	2570	Cash on Delivery	PENDING	\N	100	\N	f	\N	\N	2025-02-20 18:56:03.944	2025-02-20 18:56:03.944	\N	\N	0	\N	f	ONLINE
da30a573-749d-49d8-91f6-23e53c91aec8	04919902-1fd3-43e4-b8b7-263543b9f6fa	\N	1376650	Deepta Barua	01775172680	Dhaka	Dhaka	deepta.barua@northsouth.edu	Dhaka	1212	1	2200	2570	Cash on Delivery	PENDING	\N	100	\N	f	\N	\N	2025-02-20 19:35:44.918	2025-02-20 19:35:44.918	\N	\N	0	\N	f	ONLINE
01d10e2d-67dd-4311-984a-a13816c43c56	6a741d0b-e5d3-4ff6-b841-986a79cdce6f	\N	0082510	Shamim Rahman	01827364523	Dhaka	Dhaka	shamimrahman920@gmail.com	Dhaka	1111	1	2200	2570	Cash on Delivery	PENDING	\N	100	\N	f	\N	\N	2025-02-20 19:50:16.806	2025-02-20 19:50:16.806	\N	\N	0	\N	f	ONLINE
bae4b6dd-f76f-4a34-b562-294357a15eea	6a741d0b-e5d3-4ff6-b841-986a79cdce6f	\N	2449091	Shamim Rahman	01827364523	Dhaka	Dhaka	shamimrahman920@gmail.com	Dhaka	1111	1	3500	4300	Cash on Delivery	PENDING	\N	100	\N	f	\N	\N	2025-02-20 19:54:15.66	2025-02-20 19:54:15.66	\N	\N	0	\N	f	ONLINE
25c49285-1c2f-443d-9b2d-c8b0c7f51541	6a741d0b-e5d3-4ff6-b841-986a79cdce6f	\N	3551050	Shamim Rahman	01827364523	Dhaka	Dhaka	shamimrahman920@gmail.com	Dhaka	1217	1	3500	4375	Cash on Delivery	SHIPPED	\N	100	\N	f	\N	\N	2025-02-21 20:06:12.733	2025-02-21 21:07:10.154	\N	\N	0	\N	f	ONLINE
cfef4fee-3368-458f-9f12-61c215706a97	6a741d0b-e5d3-4ff6-b841-986a79cdce6f	\N	4498050	Shamim Rahman	01827364523	Dhaka	Dhaka	shamimrahman920@gmail.com	Dhaka	1111	1	2200	2570	Cash on Delivery	DELIVERED	\N	100	\N	f	\N	\N	2025-02-20 19:57:39.016	2025-02-21 21:15:05.364	\N	\N	0	\N	f	ONLINE
702ca9c2-612e-4ca5-a68f-71db0ef2e0b7	6a741d0b-e5d3-4ff6-b841-986a79cdce6f	\N	8089350	Shamim Rahman	01827364523	Dhaka	Dhaka	shamimrahman920@gmail.com	Dhaka	1217	1	1600	2550	Cash on Delivery	CANCELED	\N	100	\N	f	\N	\N	2025-02-22 08:10:12.516	2025-02-22 08:12:15.401	\N	\N	0	\N	f	ONLINE
d17aacce-2dbc-4c93-aa95-7dc650d0a037	6a741d0b-e5d3-4ff6-b841-986a79cdce6f	\N	5113870	Shamim Rahman	01827364523	Dhaka	Dhaka	shamimrahman920@gmail.com	Dhaka	1217	1	3500	4300	Cash on Delivery	DELIVERED	\N	100	\N	f	\N	\N	2025-02-22 08:22:01.779	2025-02-22 08:22:44.069	\N	\N	0	\N	f	ONLINE
3911122d-ade8-42e3-8809-d326271457e8	6a741d0b-e5d3-4ff6-b841-986a79cdce6f	\N	1770371	Shamim Rahman	01827364523	Dhaka	Dhaka	shamimrahman920@gmail.com	Dhaka	1217	1	1600	2550	Cash on Delivery	DELIVERED	\N	100	\N	f	\N	\N	2025-04-03 18:04:39.854	2025-04-03 18:57:29.018	\N	\N	0	\N	f	ONLINE
0082c3ae-47a4-41db-a9cb-a99d51155436	6a741d0b-e5d3-4ff6-b841-986a79cdce6f	\N	8359650	Shamim Rahman	01827364523	Dhaka	Dhaka	shamimrahman920@gmail.com	Dhaka	1217	1	2200	2570	Cash on Delivery	PENDING	\N	100	\N	f	\N	\N	2025-08-26 15:58:21.665	2025-08-26 15:58:21.665	\N	\N	0	\N	f	ONLINE
34d5a2e4-dc50-42fe-9467-481ac2b5a134	6a741d0b-e5d3-4ff6-b841-986a79cdce6f	\N	1141781	Shamim Rahman	01827364523	Dhaka	Dhaka	shamimrahman920@gmail.com	Dhaka	1217	1	1600	2550	Cash on Delivery	PENDING	\N	100	\N	f	\N	\N	2025-08-27 20:55:25.627	2025-08-27 20:55:25.627	\N	\N	0	\N	f	ONLINE
a971ee6f-2e81-4153-bbe7-f27189c978f4	6a741d0b-e5d3-4ff6-b841-986a79cdce6f	\N	2045940	Shamim Rahman	01827364523	Dhaka	Dhaka	shamimrahman920@gmail.com	Dhaka	1217	2	3800	5020	Cash on Delivery	PENDING	\N	100	\N	f	\N	\N	2025-08-27 20:56:55.57	2025-08-27 20:56:55.57	\N	\N	0	\N	f	ONLINE
f47a8b24-fba3-4fe1-879b-bd918026b33f	6a741d0b-e5d3-4ff6-b841-986a79cdce6f	\N	2593481	Shamim Rahman	01827364523	Dhaka	Dhaka	shamimrahman920@gmail.com	Dhaka	1217	2	3200	5000	Cash on Delivery	DELIVERED	\N	100	\N	f	\N	\N	2025-08-28 05:17:51.147	2025-08-28 10:04:30.131	\N	\N	0	\N	f	ONLINE
46223f8c-9daf-4719-b322-b711e3e6f23d	\N	\N	8172830	Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	bailyroad	1217	2	7000	8630	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-11 21:07:04.217	2025-09-11 21:07:04.217	\N	\N	0	\N	f	ONLINE
8adb1f1a-8677-4d50-bac5-589a573ee030	\N	\N	1840820	Shamim Rahman	01748399860	shamimrahman920@gmail.com		shamimrahman920@gmail.com	bailyroad	1217	1	5500	6830	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-11 21:13:34.897	2025-09-11 21:13:34.897	\N	\N	0	\N	f	ONLINE
f6c8ca30-7de1-414f-9455-f31d2048f69f	\N	\N	8085060	Shamim Rahman	01748399860	shamimrahman920@gmail.com		shamimrahman920@gmail.com	bailyroad	1217	1	1500	1880	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-11 21:23:35.535	2025-09-11 21:23:35.535	\N	\N	0	\N	f	ONLINE
978851bc-5b6a-4143-8a8b-54a5efbfb38e	\N	\N	8340640	Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	bailyroad	1217	1	5500	6830	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-11 21:24:14.828	2025-09-11 21:24:14.828	\N	\N	0	\N	f	ONLINE
a7389dee-7c39-478b-8a31-2a5b93634047	\N	\N	8748831	Shamim Rahman	01748399860	Kakrail			bailyroad	1217	1	1500	1880	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-11 21:24:41.921	2025-09-11 21:24:41.921	\N	\N	0	\N	f	ONLINE
aedd5508-344a-46b3-a714-ff0f7246c4bd	\N	\N	7648530	Shamim Rahman	01748399860	Kakrail			bailyroad	1217	1	1700	2150	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-11 21:39:30.211	2025-09-11 21:39:30.211	\N	\N	0	\N	f	ONLINE
91af7d2d-bf83-41a1-bb5f-f681139dfcc9	\N	\N	8539381	Shamim Rahman	01748399860	Thomas Tower			Dhaka	kakrail	1	1500	1880	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-11 21:41:17.719	2025-09-11 21:41:17.719	\N	\N	0	\N	f	ONLINE
07a2ed8a-d377-453e-8532-cf3ad0a11733	\N	\N	9183530	Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	bailyroad	1217	1	1700	2150	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-11 21:42:04.625	2025-09-11 21:42:04.625	\N	\N	0	\N	f	ONLINE
9e06053b-aa26-4a31-bdba-adcea85e09b7	\N	\N	9945811	Shamim Rahman	01748399860	thomas tower			Dhaka	kakrail	1	1500	1880	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-11 21:43:37.163	2025-09-11 21:43:37.163	\N	\N	0	\N	f	ONLINE
803c2a9f-0b1b-4d62-995e-a1be20008b6e	\N	\N	1121661	Shamim Rahman	0174839869	kakrail			Dhaka	Thomas Tower	1	1700	2150	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-11 21:45:41.661	2025-09-11 21:45:41.661	\N	\N	0	\N	f	ONLINE
aacf29a1-e545-4cf6-9a91-8cd7d10ef821	\N	\N	3454821	Shamim Rahman	01748399860	thomas tower			Dhaka	kakrail	3	5900	7420	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-11 21:49:31.294	2025-09-11 21:49:31.294	\N	\N	0	\N	f	ONLINE
c2311202-d148-43f8-aa89-22725a5e1051	\N	\N	0231620	Shamim Rahman	01748399860	Thomas Tower			Dhaka	kakrail	1	2000	2580	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-11 22:01:03.085	2025-09-11 22:01:03.085	\N	\N	0	\N	f	ONLINE
b40b5ae4-107e-437e-b841-0e780ca6f865	\N	\N	1998971	Shamim Rahman	01748399860	Thomas tower			Dhaka	kakrail	1	2000	2580	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-12 05:17:16.308	2025-09-12 05:17:16.308	\N	\N	0	\N	f	ONLINE
ad31babe-9a64-4313-8693-cbc7b286d53d	\N	\N	7943881	Shamim Rahman	01748399860	Thomas Tower			Dhaka	Kakrail	2	4000	5080	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-12 09:20:36.077	2025-09-12 09:20:36.077	\N	\N	0	\N	f	ONLINE
5eacd7ec-81d6-4014-b934-12d26f758c39	\N	\N	6895570	Shamim Rahman	01748399860	Thomas Tower			Dhaka	Kakrail	3	4000	5080	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-12 10:08:33.881	2025-09-12 10:08:33.881	\N	\N	0	\N	f	ONLINE
3a09946a-e9c7-45bb-86c1-f9b85bf2ef2b	\N	\N	6355721	Hridoy 	01622534977	Dhaka 110 santi nagar		hkhridoykhan2016@gmail.com	Dhaka	Dhaka	1	2000	2580	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2025-09-15 22:34:36.918	2025-09-16 17:53:10.295	\N	\N	0	\N	f	ONLINE
c7f78239-9d0b-4442-88ba-eec58a6f1c57	\N	\N	1830320	Hridoy 	01622534977	Chittagong agrabad		hkhridoykhan2016@gmail.com	Chittagong 	Chittagong 	1	2000	2580	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2025-09-14 20:54:17.217	2025-09-16 17:53:37.083	\N	\N	0	\N	f	ONLINE
2589629b-9a61-43e2-952f-0f6845e3b1fd	\N	\N	6524341	Cvubivj	01776608417	G g g h 			Sylhet 	T g hh vh	4	4000	5080	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2025-09-12 16:48:27.472	2025-09-16 17:53:45.995	\N	\N	0	\N	f	ONLINE
50378a12-48e8-4832-9b9e-7abed8b8d8c9	\N	\N	3614151	Shamim Rahman	01748399860	Kakrail			bailyroad	1217	1	1200	2580	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-16 17:56:06.017	2025-09-16 17:56:06.017	\N	\N	0	\N	f	ONLINE
ff1a33c2-29f1-4435-995f-88389e8d5abd	\N	\N	7297890	Shamim Rahman	01748399860	Thomas Tower			Dhaka	Kakrail 	1	2000	2580	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-17 20:09:15.376	2025-09-17 20:09:15.376	\N	\N	0	\N	f	ONLINE
f194e61e-466e-495d-937c-937c702d8b37	\N	\N	1222360	Shamim Rahman	01748399860	Kakrail			bailyroad	1217	2	4000	5080	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-19 22:32:30.811	2025-09-19 22:32:30.811	\N	\N	0	\N	f	ONLINE
35ceaa10-154d-4db4-a991-ad64ff20b234	\N	\N	9577320	Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	bailyroad	1217	1	1000	1680	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-19 22:46:14.036	2025-09-19 22:46:14.036	\N	\N	0	\N	f	ONLINE
7f59008e-7a94-4a68-89e1-b10f23a6baaa	\N	\N	5144470	Shamim Rahman	01748399860	Thomas Tower		shamimrahman920@gmail.com	Dhaka	kakrail	1	2000	2580	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-19 22:55:59.779	2025-09-19 22:55:59.779	\N	\N	0	\N	f	ONLINE
acf1c3a6-0a80-4d7e-a71f-d3e7e5a9177c	\N	\N	8703691	Sam???s wife	01712930159	Same		raisaaa7472@gmail.com	Sylhet	Akhaliya R/A	3	5000	6520	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-20 04:02:16.705	2025-09-20 04:02:16.705	\N	\N	0	\N	f	ONLINE
98101cf1-be25-4449-af85-dd1def8bc85d	\N	\N	7346760	Santo 	01625227653	Uttara 10 number road 10		afmsanto@gmail.con	Dhaka 	Uttara	1	2000	2580	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-20 11:30:06.294	2025-09-20 11:30:06.294	\N	\N	0	\N	f	ONLINE
07362a3f-2b35-453b-8823-1bad21736139	\N	\N	6033141	Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	bailyroad	1217	1	2000	2150	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-20 20:36:49.303	2025-09-20 20:36:49.303	\N	\N	0	\N	f	ONLINE
cc3318e4-97f4-4e43-ac04-d2b866ca9dd5	\N	\N	6322940	Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	bailyroad	1217	1	2500	3280	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-20 20:37:17.025	2025-09-20 20:37:17.025	\N	\N	0	\N	f	ONLINE
0d09539c-4b2e-4c6f-9ad6-edf8c762e494	\N	\N	7512331	Shamim Rahman	01748399860	Kakrail			Dhaka	1217	1	2000	2580	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-21 09:59:18.044	2025-09-21 09:59:18.044	\N	\N	0	\N	f	ONLINE
639f770f-d9fd-43b3-a605-2fb15b1e607c	\N	\N	1115621	Shamim Rahman	01748399860	Kakrail			Dhakad	1217	1	2000	2580	Cash on Delivery	PENDING	\N	\N	80	f	\N	\N	2025-09-21 10:05:26.649	2025-09-21 10:05:26.649	\N	\N	0	\N	f	ONLINE
6973ff92-f6c4-4a29-a5df-04563ff9d4eb	\N	\N	3461650	Shamim Rahman	01748399860	Kakrail			dhaka	1217	1	2000	2580	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-21 10:09:22.104	2025-09-21 10:09:22.104	\N	\N	0	\N	f	ONLINE
383c97f2-7cde-4116-9b47-40ff80f293f8	\N	\N	3807851	Shamim Rahman	01748399860	Kakrail			Khulna	1217	1	2000	2620	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2025-09-21 10:09:54.795	2025-09-21 10:09:54.795	\N	\N	0	\N	f	ONLINE
d982bcd6-d357-4eae-a935-e45137aa809f	\N	\N	4175080	Shamim Rahman	01748399860	Kakrail			Khulna	1217	1	2000	2620	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2025-09-21 10:10:24.841	2025-09-21 10:10:24.841	\N	\N	0	\N	f	ONLINE
458684f8-ccf4-4152-8a22-993ae39a2c1a	\N	\N	9211931	Shamim Rahman	01748399860	Mansion 			Ctg	Agrabad	2	4000	5120	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2025-09-21 10:35:52.584	2025-09-21 10:35:52.584	\N	\N	0	\N	f	ONLINE
34442f2f-b69f-4950-a989-bfd4357e0378	\N	\N	6266001	Shamim Rahman	01748399860	Kakrail			Khulna	1217	1	2000	2620	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2025-09-21 13:50:37.677	2025-09-21 13:50:37.677	\N	\N	0	\N	f	ONLINE
196e93dd-3a33-4385-aab0-011b4a1313e7	\N	\N	7594960	Shamim Rahman	01748399860	Kakrail			Khulna	1217	1	2000	2620	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2025-09-21 13:52:45.062	2025-09-21 13:52:45.062	\N	\N	0	\N	f	ONLINE
84664131-6be8-4755-8351-15e0a1c41890	\N	\N	9612930	Shamim Rahman	01748399860	Kakrail			Khulna	1217	1	2000	2620	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2025-09-21 13:56:05.551	2025-09-21 13:56:05.551	\N	\N	0	\N	f	ONLINE
26508828-cc05-40df-b73c-c754541ddcb7	\N	\N	1660710	Shamim Rahman	01748399860	Kakrail			Khulna	1217	1	2000	2620	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2025-09-21 13:59:30.45	2025-09-21 13:59:30.45	\N	\N	0	\N	f	ONLINE
7ff0ba32-a33e-46aa-97ce-55625ff9fcc0	\N	\N	4595630	Shamim Rahman	01748399860	Kakrail			Khulna	1217	1	2000	2620	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2025-09-21 14:04:26.009	2025-09-21 14:04:26.009	\N	\N	0	\N	f	ONLINE
cf7acb10-f1d5-4296-9af6-78d0fc787555	\N	\N	5824681	Shamim Rahman	01748399860	Kakrail			Khulna	1217	1	2000	2620	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2025-09-21 14:06:27.716	2025-09-21 14:06:27.716	\N	\N	0	\N	f	ONLINE
42f91c22-8a52-400f-9afc-31ac93f50dbd	\N	\N	8852290	Shamim Rahman	01748399860	Kakrail			Khulna	1217	1	2000	2190	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2025-09-21 14:11:30.901	2025-09-21 14:11:30.901	\N	\N	0	\N	f	ONLINE
94943f05-3e95-4517-97dd-9c32d2fe5fdb	\N	\N	9780981	Shamim Rahman	01748399860	Kakrail			Khulna	1217	1	1000	1560	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2025-09-21 14:13:02.261	2025-09-21 14:13:02.261	\N	\N	0	\N	f	ONLINE
0982ef10-9940-4ad7-a15d-3d929036c33c	\N	\N	0970611	Shamim Rahman	01748399860	Kakrail			Dhaka	1217	1	5500	6830	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-21 14:15:05.397	2025-09-21 14:15:05.397	\N	\N	0	\N	f	ONLINE
8c83b77f-0412-45ba-9d9e-5df8252b7df8	\N	\N	2068200	Shamim Rahman	01748399860	Kakrail			Dhaka	1217	1	2000	2580	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-21 14:16:52.454	2025-09-21 14:16:52.454	\N	\N	0	\N	f	ONLINE
f67de6c9-59d3-4dab-a688-16190634cd61	\N	\N	2812150	Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	Sylhet	Akhalia	1	2000	2620	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2025-09-21 14:18:17.046	2025-09-21 14:18:17.046	\N	\N	0	\N	f	ONLINE
2469f77a-f233-4db0-96ab-f58c4b073929	\N	\N	8969300	Yasin Ahmed 	01712581668 	3/A New Bailey Road Dhaka - 1000		yasinrana420@gmail.com	Dhaka	Dhaka	1	2000	2580	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2025-09-21 14:28:51.115	2025-09-21 14:28:51.115	\N	\N	0	\N	f	ONLINE
77f5452d-e956-4812-bab1-5810d5547698	\N	\N	3248860	Shamim Rahman	01748399860	same			ctg	agrabad	2	2000	2620	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2025-09-23 10:12:40.517	2025-09-23 20:21:59.868	\N	\N	0	\N	f	ONLINE
846b8329-f5b6-4496-a335-8bfcbc6e1144	\N	\N	7099441	shamim	01748399860	Sun villa			Sylhet	Jalalabad	3	5800	7100	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2025-09-21 14:42:33.55	2025-09-23 20:22:33.735	\N	\N	0	\N	f	ONLINE
5d355b33-56b3-430a-8136-5da382ff58b7	\N	\N	7059071	Shamim Rahman	01748399860	test			dhaka	test	1	2000	2580	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2025-09-24 04:05:40.554	2025-09-24 19:45:31.992	\N	\N	0	\N	f	ONLINE
79a87d28-bbbd-401f-8417-b46857e203e0	\N	\N	0043581	Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	Sylhet	Akhalia	3	8700	11127.5	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2025-09-26 20:03:30.353	2025-09-29 22:30:37.573	\N	\N	0	\N	f	ONLINE
781912e4-dcdc-4dda-b50e-e774491b03ba	\N	\N	1717371	Shamim	01748399860	Thomas Tower		shamim@gmail.com	Dhaka	Kakrail	2	9500	13330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2025-10-02 11:24:05.04	2025-10-03 14:03:56.404	\N	\N	0	\N	f	ONLINE
bf9792f4-38d9-4427-849b-965b1fbe91ed	\N	\N	1807350	Jahid 	01622534977	Dhaka santi nagar dhaka 		hkhridoykhan2016@gmail.com	Dhaka	Santi nagar 	1	4000	6580	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2025-10-01 20:40:19.992	2025-10-03 14:04:04.028	\N	\N	0	\N	f	ONLINE
9501beb7-827b-4dce-b915-b7fc7d9695f9	\N	\N	6126790	Ali	1234	101/1, Mirpur, Dhaka 		rashid.ali49208@gmail.com	Dhaka 	Dhaka	1	2500	2820	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2025-10-01 14:07:44.788	2025-10-03 14:04:11.367	\N	\N	0	\N	f	ONLINE
f26cf7d0-5911-419c-be7b-c369d2748ed8	\N	\N	7093410	Sahir	01674790699	dhaka			???????????? 	dhaka	1	1900	2370	Cash on Delivery	RETURNED	\N	\N	120	f	\N	\N	2025-09-26 11:56:31.584	2025-10-03 14:04:17.186	\N	\N	0	\N	f	ONLINE
099d7994-4d37-4ac5-ac63-6243438923e8	\N	\N	4977870	Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	Sylhet	Akhalia	1	2000	2620	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2025-10-08 16:38:22.671	2025-10-08 18:40:50.452	\N	\N	0	\N	f	ONLINE
e5651ee7-91aa-4306-a7d6-2edeacfaa3c1	\N	\N	8926711	Monmoy	0164747483	Eskaton		monmoy@gmail.com	Dhaka	Eskaton	1	2000	2380	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2025-10-07 04:55:51.253	2025-10-08 18:40:54.743	\N	\N	0	\N	f	ONLINE
8e73a62a-762e-4b35-8f89-92563de82426	\N	\N	9301460	Maruf hasan Niloy 	01816801545	Hossendy Bazar 1511			Munshiganj 	Gazaria 	1	2000	2190	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2025-10-15 08:47:46.217	2025-10-19 06:37:04.172	\N	\N	0	\N	f	ONLINE
aad8dd43-0c78-484f-ab5d-17e2fef173d8	\N	\N	3840510	Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	Dhaka	Dhaka	2	6300	7020	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2025-10-14 19:23:34.923	2025-10-19 06:37:13.26	\N	\N	0	\N	f	ONLINE
ba2967ff-7d44-4551-bcf5-dfcb6939e3e1	\N	\N	8504740	Shamim Rahman	01748399860	thomas			Dhaka	kakrail	2	3000	4020	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2025-09-25 14:17:51.088	2025-10-23 14:33:24.95	\N	\N	0	\N	f	ONLINE
531e06ff-5049-472c-a512-6714335fcf44	\N	\N	8894321	shamim	01748399860	test			dhaka	test	1	2000	2580	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2025-09-24 03:51:54.727	2025-10-23 14:33:34.311	\N	\N	0	\N	f	ONLINE
471037f2-cb86-4e81-b01f-1d2ab0f820bd	\N	\N	0136430	ariyan	12121212	6/1, Kallyanpur, Dhaka.		rashid.ali49208@gmail.com	Dhaka	Kallyanpur	2	8000	13080	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2025-10-24 17:31:20.234	2025-10-26 09:11:14.362	\N	\N	0	\N	f	ONLINE
2d408be5-a0ff-4348-87e8-fd1e66461119	\N	\N	2356160	Ariyan	12121212	6/1, Kallyanpur, Dhaka.		rashid.ali49208@gmail.com	Dhaka	Kallyanpur	1	4000	5580	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2025-10-24 17:34:52.482	2025-10-26 09:11:23.761	\N	\N	0	\N	f	ONLINE
a7742836-6069-402e-b20a-6c8dc304874a	\N	\N	0099391	Iqbal Hydar 	01627373599	Foujdarhat, Abdullar ghata,Sitakundu, Chattogram 			Chattogram 	Foujdarhat 	1	2000	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2025-10-25 16:01:19.448	2025-10-27 17:41:37.956	\N	\N	0	\N	f	ONLINE
45ec9bda-867a-44c7-8da9-162ff3a2ab77	\N	\N	3760431	Mohammad Jabed	01749091319	Baridhara J block Road 08		mdjabed4042@gmail.com	Dhaka	Baridhara J block Road 08	1	2500	2780	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2025-10-27 16:11:20.872	2025-10-27 18:16:00.06	\N	\N	0	\N	f	ONLINE
02cd594d-f0d1-47d0-a827-0fd1f5c4909f	\N	\N	6031351	Shamim Rahman	01748399860	test			ctg	test	3	2000	2620	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2025-09-24 03:47:36.284	2025-10-28 11:58:19.68	\N	\N	0	\N	f	ONLINE
1c1f0f28-a604-472d-bc8e-57d7bf91a5b2	\N	\N	7012650	Shamim	01748399860	Thomas Tower			Dhaka	Kakrail	1	2500	3280	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2025-09-23 06:42:09.955	2025-10-28 11:58:26.946	\N	\N	0	\N	f	ONLINE
115bd080-6b20-492e-9981-a12889e6d298	\N	\N	8312970	Shamim Rahman	01748399860	Villa			Dinajpur	Fulbari	2	3800	4600	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2025-09-22 19:54:26.692	2025-10-28 11:58:35.002	\N	\N	0	\N	f	ONLINE
6892de49-67be-4d9f-8e78-1f6af8548b32	\N	\N	1785370	Rafiqul Sun	01798829063	Betka bazar near National cold storage		sunkhan100.sk@gmail.com	Munshigonj	Betka, Tongibari, Munshigonj	1	2000	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2025-11-04 17:11:35.274	2025-11-05 19:33:42.468	\N	\N	0	\N	f	ONLINE
3b42bc0b-8282-4e88-a2aa-ae1a21c7e4c7	\N	\N	7244531	Sahil Faiyaz	01905249631	Aftabnagar A block 2no road house 25 Safa marwa cottage Dhaka		sahilfaiyaz8@gmail.com	Dhaka	Aftabnagar A block 2no road house 25 Safa marwa cottage	1	1500	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2025-11-05 15:51:07.663	2025-11-05 19:45:23.484	\N	\N	0	\N	f	ONLINE
aa5a0bbf-04ba-4f83-bd54-5d93adbf7920	\N	\N	1216801	Apon	01714409464	Bashundhara ra block k road 8 house 417 		apon4677@gmail.com	Dhaka	Bashundhara ra	1	2000	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2025-11-15 12:52:40.326	2025-11-15 15:11:42.776	\N	\N	0	\N	f	ONLINE
3ea4903e-be09-4476-a5c1-d9e881851d11	\N	\N	2925431	Hridoy	01622534977	Aqp shopping mall			Dhaka	Baiy road dhaka	1	4000	6580	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2025-11-16 22:49:02.986	2025-11-20 17:44:47.295	\N	\N	0	\N	f	ONLINE
08f609ac-1cd4-4e71-9d7a-b124b9cdf514	\N	\N	8253980	Rafin Shahriar	01576536893	Block e road 5 house 27 banasree rampura		rafinshahriar3153@gmail.com	Dhaka	Block e road 5 house 27 banasree rampura	1	1500	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2025-11-27 07:51:23.119	2025-12-01 09:15:35.833	\N	\N	0	\N	f	ONLINE
05d80820-4429-46f8-a730-8731863c8667	\N	\N	6553080	Md. Shamim Rahman	01748399860	Kakrail	\N	shamimrahman920@gmail.com	Dhakaf	\N	1	2500	2700	Cash on Delivery	DELIVERED	\N	\N	\N	f	\N	\N	2025-11-28 18:47:44.775	2025-12-01 09:15:43.009	\N	\N	0	\N	f	ONLINE
454c25a5-7aee-4448-ae65-5dfc0f8c00b2	\N	\N	8565500	Fahid hassan Sonet	01716252658	Sonet electric And machineries station road bogura 		fhassan252658@gmail.com	Bogura	Bogura sadar	1	1500	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2025-11-29 19:51:52.911	2025-12-01 09:15:51.307	\N	\N	0	\N	f	ONLINE
1bc27f75-916a-4818-bd3d-14988e87bd40	\N	\N	8382130	Jubair	01911915756	??/2, Aftabnagar			Dhaka	East west university 	1	1800	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2025-12-12 08:58:05.814	2025-12-15 12:35:02.851	\N	\N	0	\N	f	ONLINE
14c5de21-8401-4bef-98dd-e106d1c7719c	\N	\N	2817250	Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	Dhaka	Dhaka	5	10000	12790	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2025-12-10 19:34:47.482	2025-12-15 12:35:09.971	\N	\N	0	\N	f	ONLINE
b7709819-17b8-448b-84f7-214f03270063	\N	\N	0767521	Rudro Saha	01770358321	Mirpur 10, road 04		lalrudro676@gmail.com	Dhaka	mirpur 10	1	1500	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2025-12-08 20:51:53.173	2025-12-15 12:35:21.5	\N	\N	0	\N	f	ONLINE
91fd2f2f-40fc-4a0d-9652-af6c2377707f	\N	\N	9904020	Rakis	01624591616	Keranigonj equrea Muslim nogor			Dhaka	Keranigonj 	1	1000	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-14 09:08:04.023	2026-07-14 10:36:30.76	\N	\N	0	\N	f	ONLINE
59f02da2-762a-4285-aaab-244de3df11f7	\N	\N	9609871	Fahad Rabbani 	01339560936	Same		rabbanifahad365@gmail.com	Sylhet	Tajpur (3123),osmaninagar,sylhet	1	3500	5970	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-23 11:44:13.414	2026-07-24 11:39:15.506	\N	\N	0	\N	f	ONLINE
fe697ce7-ce37-43fa-8765-61dd9b4c0598	\N	\N	9698670	Nayem Rahman 	01793901102	Balisahasra Clinic,MP Bazar		nayemurrahman212@gmqil.com	Moulvibazar,Sylhet 	Balisahasra,Rajnagar 	1	1500	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2025-12-10 14:31:43.625	2025-12-15 12:35:15.387	\N	\N	0	\N	f	ONLINE
026de3dd-e6f7-489f-bbcd-6ee367d2e973	\N	\N	2912861	Shamim Rahman	01748399860	thomas tower		shamimrahman920@gmail.com	dhaka	kakrail	2	9000	13080	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2025-12-27 17:08:36.487	2026-01-04 16:54:40.52	\N	\N	0	\N	f	ONLINE
e9edc958-b243-4cea-9dc2-5faa092515b5	\N	\N	1743420	Shamim Rahman	01748399860	thomas tower		shamimrahman920@gmail.com	dhaka	kakrail	1	4500	6580	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2025-12-27 17:06:47.3	2026-01-04 16:54:53.223	\N	\N	0	\N	f	ONLINE
7db4bb71-dc88-484c-8683-1c4a4f012f67	\N	\N	1492420	Fardiin Islam	01819575524	Mirpur-13,Block-C,Road no-10/1,House no-7/1		islamsparker@gmail.com	Dhaka	Mirpur	1	2000	2380	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2025-12-27 06:21:10.279	2026-01-04 16:56:04.325	\N	\N	0	\N	f	ONLINE
ba9dcf2f-77c8-4d20-86ca-5aa00d4032a0	\N	\N	9506910	Tapus	01635651914	Kalurghat Rashta matha AL Khan school		tapustripz@gmail.com	Chittagong 		1	1500	2620	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-02-18 05:54:28.907	2026-02-19 17:44:02.244	\N	\N	0	\N	f	ONLINE
e332c716-4c73-4008-8b1b-4a9cfab48e2d	\N	\N	8540370	Saif Hossain	01521432894	House#549(Bhuiyan manjil), Road-03, Ashkona, Airport		saifhossain957@gmail.com	Dhaka	Airport, Uttara-1230	1	2000	2080	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-02-10 12:37:14.861	2026-02-19 17:44:09.556	\N	\N	0	\N	f	ONLINE
2f2d1f0a-9743-4be3-a7bd-2b89364513a6	\N	\N	8035941	adar	01533433266	janina		ada6251@gmail.com	noakhaloi	sandwip	1	1500	2620	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-01-30 16:17:47.147	2026-02-19 17:44:48.544	\N	\N	0	\N	f	ONLINE
640b3fba-e04c-4965-8e8f-17076a35a888	\N	\N	3940711	Eham	01337986369	Oxford mission road 		sabiteham48@gmail.com	Barisal Oxford mission road 	Barisal 	1	2000	2620	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-01-11 15:15:07.767	2026-02-19 17:45:02.24	\N	\N	0	\N	f	ONLINE
2bcc9b36-b3aa-41cb-a566-46ddb4bbbe95	\N	\N	7935911	Ashmeet	01818370266	Rampura Banasree, A block, Road 4, hoise 19		fasaniashmeet@gmail.com	Dhaka	Dhaka	1	2000	2580	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-01-12 18:35:14.762	2026-02-19 17:45:19.415	\N	\N	0	\N	f	ONLINE
edeb4944-7a47-4216-9906-f59ebb124896	\N	\N	7354280	shanto rupom	01966223955	mirpur-1 dhaka road- 8 house-1 block-D		shantorupom46@gmail.com	dhaka	mirpur-1	1	2000	2080	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-02-27 19:17:52.731	2026-03-02 20:30:16.999	\N	\N	0	\N	f	ONLINE
3a6741f9-2a6c-4d1d-8c19-9a61d6294ff6	\N	\N	2143880	Tamim	+8801732297976	45 North Kafrul, Dhaka cantonment  		tamimmohammod28@gmail.com	Dhaka	Dhaka	1	1500	2080	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-04-16 18:14:30.015	2026-04-20 10:38:20.915	\N	\N	0	\N	f	ONLINE
af49f78d-cefd-4d5e-9a72-10363c38fddb	\N	\N	9392770	Shahriar Efti	8801792427939	Mridhabari, kuratoli bazar, kuril, Vatara		shahriarefti024@gmail.com	Dhaka	Kuril	1	2000	2380	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-04-16 08:27:39.184	2026-04-20 10:38:26.459	\N	\N	0	\N	f	ONLINE
37bcb1dc-4602-46f8-b804-4f8f3e91dafd	\N	\N	7307601	Shabab Ishmam	01709634864	Flat 8C, House 112/113, Road 5, block i, Bashundhara R A			Dhaka	Bashundhara, Dhaka	1	1500	1580	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-04-12 13:33:27.54	2026-04-20 10:38:40.397	\N	\N	0	\N	f	ONLINE
ea5c5c39-dd75-4f15-80ea-8f297a90fca1	\N	\N	2875101	Arafat Fardous Dipu	+8801858052670	khunkut model Bazar 		arafatfardousdipu@gmail.com	Narshingdi 	kondarpara .khunkut model Bazar 	2	4000	4620	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-04-02 22:52:39.753	2026-04-20 10:38:50.413	\N	\N	0	\N	f	ONLINE
89d478f3-c3fd-45d5-bd34-4241717ba5b0	\N	\N	0368280	Mahedi	01928930870	6/15 , block=E,,Lalmatiya Dhaka		mahedi9255@gmail.com	Dhaka	Lalmatiya	1	2000	2580	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-04-06 09:52:52.911	2026-04-20 10:39:01.535	\N	\N	0	\N	f	ONLINE
872d2834-d16d-4da5-912f-5e7d8d494330	\N	\N	6489100	Aditya Salunkhe	8007885002	Flat No 37 B Sneha Complex , Building B Sneha Complex Road, Behind Hyderabadi Biryani House , Behind Hyderabadi Biryani , Pune , Maharashtra,India - 411058		adityaraj9306@gmail.com	Pune	Pune	1	2000	2640	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-04-26 08:23:03.325	2026-04-26 14:21:25.359	\N	\N	0	\N	f	ONLINE
010aaec3-a8fc-4027-8c44-67d15110962e	\N	\N	2969110	Aditya	8007885002	Edyans us 37 hyda oai Bixyanui une , Saha Cora exdfa d, Behind Hyderabadi		adityaraj9306@gmail.com	Pune	Pune	1	2000	2640	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-04-26 08:48:59.403	2026-04-26 14:21:33.624	\N	\N	0	\N	f	ONLINE
fe6b7979-b4a4-4ae5-befb-454f2d55ffcc	\N	\N	1648200	Tanish	7065733692	467		tanishsharma0005@gmail.com	Haryana	Gurugram 	2	1700	2640	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-04-26 12:23:20.282	2026-04-26 14:21:40.421	\N	\N	0	\N	f	ONLINE
10e974f3-51b0-4d75-b356-23985f129089	\N	\N	6972001	Muntaha	01914871312	31/8, block-D, sher shah shuri road, mohammadpur,Dhaka-1207		muntaharahman02@gmail.com	Dhaka	Mohammadpur	1	1500	2150	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-04-27 09:56:29.104	2026-04-27 12:29:49.192	\N	\N	0	\N	f	ONLINE
73acece5-e404-481e-8d10-5faaa0b27f7f	\N	\N	9680190	Sam	9958145363	C161 gujjar dairy gautam nagar new delhi - 49		sameerthatsit4@gmail.com	Delhi	New delhi	1	1700	2640	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-04-27 06:40:04.078	2026-04-27 12:29:58.718	\N	\N	0	\N	f	ONLINE
743782aa-cfc4-4838-b9e5-0ef27f2037ee	\N	\N	7050180	Mohan thapa	8099817693	Near barapathar beat house 		mohanpun87794@gmail.com	East Khasi hills	Meghalaya 	1	1700	2370	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-04-26 19:46:47.484	2026-04-27 12:30:04.492	\N	\N	0	\N	f	ONLINE
fbaaf261-d94e-442f-afea-32cd3c4b91ff	\N	\N	7937091	SACHIN	9565343388	BG 419 Radha Krishna Niwas Flat 302 Dwarka Sector 8, 110077		sachinbehl0719@gmail.com	Delhi	New Delhi	1	2000	2640	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-04-26 18:07:50.564	2026-04-27 12:30:10.693	\N	\N	0	\N	f	ONLINE
82098dfc-6511-4fdf-8b08-65b5b87739ec	\N	\N	7456031	MD Panth Reza Sabbir 	01886922448	House 15 DEX office 		panthreza403@gmail.com	Dhaka	Dhaka Uttara Sector 1	1	1700	260	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2026-04-26 17:34:34.137	2026-04-27 12:30:16.793	\N	\N	0	\N	f	ONLINE
cff42021-08c8-4843-9c64-d4134f6df07c	\N	\N	1446580	Harsh jaiswar 	7756865336	Laxmi palace anna saheb patli nagar near Sai baba temple 		harshjaiswar110@gmail.com	Thane 	Maharalgaon	1	1700	2640	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-04-26 16:17:04.666	2026-04-27 12:30:23.602	\N	\N	0	\N	f	ONLINE
64f0f6dd-dce7-4aa1-814d-48908838caca	\N	\N	4806551	Zaid 	9881989083	1718 c ward Somwar peth near kasab masjid Kolhapur 		ZaidThodge@gmail.com	Maharashtra 	Kolhapur 	1	2000	2640	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-04-26 16:23:09.306	2026-04-27 12:30:28.854	\N	\N	0	\N	f	ONLINE
a6382d0b-bfac-4729-bfce-9dc6fdf792c8	\N	\N	7897541	Durvang	8104226859	Traditional Chinese, Khardev nagar, Ghatla, Chembur, Mumbai- 400071		durvangarekar@gmail.com	Mumbai	Mumbai	1	1500	1920	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-04-26 17:01:18.208	2026-04-27 12:30:33.379	\N	\N	0	\N	f	ONLINE
224fe4b8-0d83-4182-8fd9-b77dff95f41b	\N	\N	3255420	Rahin	01304285358	Kotarkuna, kulaura, moulvibajar 		mrrahin0808@gmail.com	Kulaura	Kotarkuna, kulaura, moulvibajar 	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-04-30 15:36:12.641	2026-05-08 11:52:57.497	\N	\N	0	\N	f	ONLINE
0774a2a4-9457-4ff0-9173-87f5aa7288ce	\N	\N	9877230	Zarif 	01323424926	Ononto Bazar Pabna. pabna sadar 		zalochon207@gmail.com	Pabna	Pabna sadar	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-05-08 09:03:45.554	2026-05-08 16:30:55.825	\N	\N	0	\N	f	ONLINE
ae079f16-d834-4271-a570-2c2d6278d832	\N	\N	9901011	Rahman Nafis	+8801703612651	Passport Office Road, Manikganj Sadar		yournafis22@gmail.com	Manikganj 	Manikganj Sadar 	1	1200	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-05-09 08:08:10.422	2026-05-09 09:54:29.265	\N	\N	0	\N	f	ONLINE
59f85efa-604c-4420-9653-38372f0cb8d9	\N	\N	0669440	Anurag das	8327756216	Godrej park retreat house no g1004,g tower 10th floor		anurag1996.das@gmail.com	Karnataka 	Bangalore,pin-560035	1	2000	2640	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-05-11 09:19:10.921	2026-05-11 09:39:07.539	\N	\N	0	\N	f	ONLINE
9e672d14-e96a-41e5-8427-2f30d8f1f95a	\N	\N	0579200	Ridwan Emon	+8801615460541	1229		raditridwan@gmail.com	Dhaka 	Khailkhet Bazar 	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-05-11 22:38:53.159	2026-05-12 10:21:11.246	\N	\N	0	\N	f	ONLINE
7b3bc2ac-6d3f-4ec6-b846-210320e6d50e	\N	\N	5060861	RAWAT saab	7009713524	Virka Pind		kuldeepsinghh7828@gmail.com	Kapurthalla	Virka pind phagwara punjab	1	1500	2190	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-05-13 09:29:18.238	2026-05-13 14:53:46.788	\N	\N	0	\N	f	ONLINE
fcd32e27-dd4c-4222-a74d-b5b41aeae0aa	\N	\N	5276481	Kaisar	01317684584	Gachbaria		mdk039157@gmail.com	Chittagong 	Chandanish gachbaria	1	1700	2370	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-05-13 07:34:03.959	2026-05-13 14:53:52.378	\N	\N	0	\N	f	ONLINE
69704e14-9786-47a0-8c80-635f3fc5bdc0	\N	\N	8680101	Mahfuz Rahman 	01860679269 	City University, Fazlur Rahman hall 		mdshuvo987654321@gmail.com	Dhaka	khagan Asulia 	1	1500	2150	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-05-14 08:56:59.435	2026-05-15 23:24:28.682	\N	\N	0	\N	f	ONLINE
297f018a-6243-49fc-aa72-8991076417e5	\N	\N	6508390	Anurag Das	8327756217	Godrej park retreat g tower house no g1004 ,10th floor		anurag1996.das@gmail.com	Karnataka 	Bangalore ,560035	1	2000	2640	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-05-14 08:51:59.581	2026-05-15 23:24:33.699	\N	\N	0	\N	f	ONLINE
ccfa408a-c6e5-4606-8e9e-19180715ff0e	\N	\N	7178761	Mahin Hasan Upol	01974093581	Purba varata masjid, sayeednagar, Vatara, Dhaka north, Dhaka		mahinhasanupol@gmail.com	Dhaka north 	Purba varata masjid, sayeednagar, Vatara, Dhaka north, Dhaka	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-05-16 15:52:59.378	2026-05-17 15:20:54.679	\N	\N	0	\N	f	ONLINE
4afba2be-4d5d-48aa-9465-06adef5aa699	\N	\N	9285180	MD shihab	01798650121	Khayer had hospital			Bhola	Duluth khan 	1	1200	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-05-18 08:30:49.049	2026-05-18 11:51:26.177	\N	\N	0	\N	f	ONLINE
6c873d67-a715-4368-831f-aa0ddf780710	\N	\N	8565400	Arpit talwar	8954455446	5a/47/b nit faridabad		talwararpit882@gmail.com	Haryana	Faridabad 	1	1200	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-05-18 00:58:56.735	2026-05-18 11:51:31.354	\N	\N	0	\N	f	ONLINE
143418e3-68cb-46e0-bbe3-0eec534ecfc9	\N	\N	7335371	Mintu	6291220181	Bosetala dhapa near kali mandir		mintunishad745@gmail.com	India	Kolkata	1	2000	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-05-18 20:06:10.978	2026-05-19 12:08:15.309	\N	\N	0	\N	f	ONLINE
7cb9fe30-b38a-4906-b4ef-54b06524a0ae	\N	\N	4688340	Tanvir Mirza 	01707705938	Suhilpur College gate 			Brahmanbaria 	Sador 	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-05-20 08:58:56.549	2026-05-21 15:31:35.747	\N	\N	0	\N	f	ONLINE
7dbb21b1-68eb-457a-bc3e-05c1ac5e6ec3	\N	\N	5912950	Tanvir Mirza 	01707705938	Suhilpur College gate 			brahmanbaria 	Sador 	1	1700	2190	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-05-20 09:01:14.965	2026-05-21 15:31:43.468	\N	\N	0	\N	f	ONLINE
b9582ca5-b6fd-450f-bcca-39d2e6c65529	\N	\N	0093461	Mushfiq Chowdhury	01911571139	Ja-89/1, Hazi villa, linkroad, badda		rifat.chowdhury2000@gmail.com	Dhaka	Linkroad, Badda	1	1200	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-05-22 10:34:32.391	2026-05-24 11:49:29.212	\N	\N	0	\N	f	ONLINE
9f41323e-5cec-46ad-886d-392bac5c8a0a	\N	\N	1098911	Mehedi Hasan	01753298862	Chandpur,,Shahrasti,,, ?????????????????? ????????????, ???????????????????????? ???????????? ????????? 		mehedi108200@gmail.com	Chandpur 	Chandpur,,Shahrasti,,, ?????????????????? ????????????, ???????????????????????? ???????????? ????????? 	1	1500	2190	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-05-23 16:21:58.488	2026-05-24 20:20:25.469	\N	\N	0	\N	f	ONLINE
67d96c51-7fec-42a1-879b-7edb17e22d6c	\N	\N	8620990	Sydney Jesus Fernandes	917620683843	H.no 378/A Near Canara Bank Dando Curtorim Salcete Goa After State Bank Of India		fernandessydneyjesus@gmail.com	South 403709	Goa 	1	2000	2640	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-05-25 22:42:52.533	2026-05-25 23:29:56.824	\N	\N	0	\N	f	ONLINE
232615c1-c7a3-40bf-ab6f-dc16bba360a5	\N	\N	6055381	test	01748399860	Kakrail			Dhaka	Dhaka	4	6800	9080	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2026-05-26 19:46:05.708	2026-05-29 20:23:21.201	\N	\N	0	\N	f	ONLINE
d00b6a59-e1c2-4649-bc71-65583d52d683	\N	\N	9365991	test	01748399860	Kakrail			Dhaka	Dhaka	1	1700	2330	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2026-06-02 16:49:09.304	2026-06-03 08:32:23.667	\N	\N	0	\N	f	ONLINE
20a8b73c-027a-4ce9-b0eb-589a410d5061	\N	\N	7247000	test	01748399860	Kakrail			Dhaka	Dhaka	1	1700	2330	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2026-06-02 16:45:32.64	2026-06-03 08:32:34.829	\N	\N	0	\N	f	ONLINE
f32aa519-626b-44ca-a4a6-3923a1261269	\N	\N	0232041	Sadman Karim	01765398192	Basundhara F block 21 no road		h71thor@gmail.com	Dhaka	Basundhara 	1	1200	1880	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2026-06-01 11:42:11.63	2026-06-03 08:33:20.513	\N	\N	0	\N	f	ONLINE
903fc8aa-de65-4547-860b-4a0b28557cda	\N	\N	3213210	test	01748399860	test		test	test	test	3	1700	2370	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-05-26 12:01:11.756	2026-06-04 13:14:20.678	\N	\N	0	\N	f	ONLINE
274236ce-0927-42bb-90a3-6abd4d920aa8	\N	\N	8476760	Faysal Mahmud	01677650741	Nawab Ali Bordi Khan Road 6620 Ishwardi, pabna		faysalhere1139@gmail.com	Pabna	Ishwardi 	1	1500	2190	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-05-26 07:18:04.054	2026-06-04 13:14:12.945	\N	\N	0	\N	f	ONLINE
ec027505-e677-4b56-8b7f-0d5eb4f0ce88	\N	\N	0229961	test	01748399860	test		test	test	test	2	3400	4620	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-05-26 12:22:47.087	2026-06-04 13:14:27.015	\N	\N	0	\N	f	ONLINE
9af727d8-b413-4934-b4b1-7c66c29f74ff	\N	\N	6920191	Mosfiqur Rahman	1705724505	Sdc Training Center		hossaintamim702@gmail.com	Dhaka 	Kamarpara near by puraton turag thana 	1	1500	2370	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-06-01 11:18:40.566	2026-06-04 13:14:47.426	\N	\N	0	\N	f	ONLINE
71b153ac-c969-409d-ab00-6378ce320800	\N	\N	5134330	Mosfiqur Rahman	1705724505	Sdc Training Center		hossaintamim702@gmail.com	Dhaka 	Kamarpara near by puraton turag thana 	1	1500	2370	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-06-01 11:15:52.452	2026-06-04 13:14:58.248	\N	\N	0	\N	f	ONLINE
86beac65-ffb2-4ac1-85c6-ef7244ac57d5	\N	\N	6953021	Mosfiqur Rahman 	1705724505	SDC training center 		musfiqurtamim19@gmail.com	Dhaka	Kamarpara near by puraton turag thana 	1	1500	2330	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2026-06-01 11:02:43.565	2026-06-04 13:15:04.204	\N	\N	0	\N	f	ONLINE
c6ef6cf3-fe20-4456-82bc-3ca7b2e04b04	\N	\N	0457890	test	01748399860	test			test	test	3	4700	6510	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-05-26 14:03:11.426	2026-06-04 13:15:13.991	\N	\N	0	\N	f	ONLINE
7e5564b8-add6-4ae5-84d9-f3f20bcf0da5	\N	\N	1506570	test	01748399860	test			test	test	3	5100	6870	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-05-26 13:37:20.515	2026-06-04 13:15:19.001	\N	\N	0	\N	f	ONLINE
f1fcc763-90b8-4976-8ff7-1020c2a558f5	\N	\N	2976791	test	01748399860	test			test	test	3	4900	6690	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-05-26 13:50:46.623	2026-06-04 13:15:23.957	\N	\N	0	\N	f	ONLINE
e766fa6e-8448-4bbe-98e3-2ca06fdc64bd	\N	\N	9110600	Asadur Rahman	01911109836	11/5, Baruthkhana, Sylhet		adr4280@gmail.com	Sylhet	Baruthkhana	1	1300	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-13 23:39:32.114	2026-07-14 10:33:02.795	\N	\N	0	\N	f	ONLINE
46f45268-0821-406d-9d61-8994c50648c3	\N	\N	1573540	Mosfiqur Rahman	1705724505	Sdc Training Center		hossaintamim702@gmail.com	Dhaka 	Kamarpara near by puraton turag thana 	1	1700	2370	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-06-01 11:28:06.916	2026-06-04 13:14:38.899	\N	\N	0	\N	f	ONLINE
9979f2d2-ca5a-4905-babe-23eafeb661f5	\N	\N	3984330	Md Hridhoy 	01408824755	nabinagar College para ,nabinagar Brahmanbaria 		shuvom1799@gmail.com	Brahmanbaria	nabinagar	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-04 14:47:31.501	2026-06-04 21:42:11.13	\N	\N	0	\N	f	ONLINE
6ba9f70c-30e8-46f4-bf8a-d4131f319e3a	\N	\N	3406950	Zobair 	01971673333	3/a kawran bazar hasney tower 11 th floor 		zubo013@yahoo.com	Dhaka	Kawran bazar	1	1500	2150	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-04 16:10:14.452	2026-06-04 21:42:19.081	\N	\N	0	\N	f	ONLINE
b4eaead8-e733-485d-90bd-1af59f3841fa	\N	\N	0458451	jhon	364936292	15			texas	usa	4	5000	5160	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-04 16:54:40.946	2026-06-04 21:42:26.159	\N	\N	0	\N	f	ONLINE
5225b38d-490f-4df1-9d2b-202a65c7ba35	\N	\N	6836990	najmul alam	01799459406	Tb hospital road rahman villah 		najmulak890	Sylhet 	Moulvibazar 	1	1700	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-04 17:05:29.401	2026-06-04 21:42:34.241	\N	\N	0	\N	f	ONLINE
859960b6-48ab-4b1e-a760-561f150569f2	\N	\N	6927720	Asif Mahmud 	01822503977	Eldorado Motin Palace Flat C7		asifsporsho@gmail.com	Dhaka	236, East Nakhalpara, Tejgaon Dhaka, 1215	1	1500	2150	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-04 18:46:02.131	2026-06-04 21:42:40.393	\N	\N	0	\N	f	ONLINE
fd123030-f3de-4a5b-be08-344012ef6e7d	\N	\N	2032731	Niketan Basak	+8801927319768	1209 Holding Number		niketanbasak@gmail.com	Kishoreganj Sadar	32,Natunpalli,Kishoreganj Sadar	1	1700	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-04 19:28:43.45	2026-06-04 21:42:46.341	\N	\N	0	\N	f	ONLINE
ab475c59-c103-43ed-a5ab-4e2c51d18585	\N	\N	9678300	Palash chakma	1641642866	Betchari bazar, naniarchar, Rangamati		polashc61@gmail.com	Rangamati 	naniarchar 	1	1500	2190	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-05 02:54:13.246	2026-06-05 04:24:50.037	\N	\N	0	\N	f	ONLINE
609642a1-b8c2-4148-b83c-777340a5bcf3	\N	\N	0276131	Mehedi hasan	01716648032	Jahanpur, 6 no word			Bhola	Jahanpur,charfasson 	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-05 04:19:32.603	2026-06-05 04:24:58.343	\N	\N	0	\N	f	ONLINE
8106679a-2fb9-490a-b5d5-5fc723a6a7ae	\N	\N	3829370	Imran Hossain	01618620990	??????????????? ?????????????????????: ??????, ??????????????????, ??????????????? ??????????????? , ????????? ???????????????, ?????? ????????????????????? 		imran.infinix01@gmail.com	????????????	?????????????????? ??????	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-06 07:26:10.918	2026-06-06 09:53:44.15	\N	\N	0	\N	f	ONLINE
42845aca-d8ff-44e8-a3ab-74ec1d9acb3e	\N	\N	5594031	Nahil Shahriar	01581009212	Talora Bazer, Dupchanchia,Bogura.		nahilshahriar4@gmail.com	Bogura	Talora, Bogura	1	1200	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-06 06:33:47.959	2026-06-06 09:53:52.487	\N	\N	0	\N	f	ONLINE
43b39607-ec88-40e0-a748-68ad91a47a2b	\N	\N	3113071	Nahil Shahriar	01581009212	Talora Bazer, Dupchanchia,Bogura.		nahilshahriar4@gmail.com	Bogura	Talora Bazer, Bogura	1	1200	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-06 06:30:53.95	2026-06-06 09:54:24.133	\N	\N	0	\N	f	ONLINE
9cba38b6-4d48-4513-8a23-3cfe5cdba4d1	\N	\N	1906061	SK. ALI MUHAMMAD Joney	01717009309	Bank Asia Plc Jashore Branch 39 Mk Road Jess Tower 1st Floor Jashore		joneyasia123@gmail.com	Jashore 	Jashore	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-06 05:53:54.143	2026-06-06 11:42:46.7	\N	\N	0	\N	f	ONLINE
03dca44c-e3c0-4cc1-8c1b-fd966e03b82f	\N	\N	6857311	Sohel Sohel	01829796470	Sadar,Suganda,cox's bzr		shahidulmustofasohel70@gmail.com	Cox's bazar	Suganda	1	1500	2190	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-06 04:55:54.274	2026-06-06 11:42:53.917	\N	\N	0	\N	f	ONLINE
9295ce2b-9f62-40c8-8a3b-f4c4e07d006b	\N	\N	0408570	Jubayer	01793676017	Lalabazar		ahmedjubayer4400@gmail.com	Sylhet 	Lalabazar,South Surma,Sylhet 	1	1200	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-06 22:48:21.732	2026-06-07 15:25:48.552	\N	\N	0	\N	f	ONLINE
2e022f6f-4ef0-4511-991a-9040ddf39288	\N	\N	4605930	Himel Tongper	0187315 3543	Jaintapur 		himeltongper@icloud.com	Sylhet	Mukampunjee jaintapur sylhet	1	1700	2370	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-06-07 10:02:43.573	2026-06-07 15:25:55.595	\N	\N	0	\N	f	ONLINE
78109608-b453-4dae-89a4-e5ea9610ee25	\N	\N	1685031	Mostofa Numaeer	01963500528	Plot # 10/E A/1 Index Mostafa Modhubag Hatirjheel Road notun rasta 		numaeermostofa@gmail.com	Dhaka	Modhubag mirbag mor, Hatirjheel road	1	1700	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-07 14:06:50.053	2026-06-07 15:26:30.916	\N	\N	0	\N	f	ONLINE
ce311229-acc9-454e-b3ff-cfce0c0b22de	\N	\N	6684660	Sakib	01774911020	Uposhohore New Market, Rajshahi 		sakib.shahanur@gmail.com	Rajshahi 	Uposhohore New Market, Rajshahi	1	2000	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-09 12:38:47.846	2026-06-09 16:40:05.216	\N	\N	0	\N	f	ONLINE
458463b2-04ba-49d6-86f8-79492abcb1fe	\N	\N	0563220	Misal	01733862772	Walton showroom er pahser road e duke 1st building,Baunia,Uttara,Dhaka		mdmisal160@gmail.com	Dhaka	Uttara,Dhaka	1	1700	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-09 12:46:52.085	2026-06-09 16:40:11.807	\N	\N	0	\N	f	ONLINE
3c0009c6-2122-4761-9121-728d71611bec	\N	\N	0443071	Afnan Taher	01841612432	4th Floor, Al Hakim plaza, Rd 1, panchlaish gol chottor, panchlaish, Chittagong 		taherafnan03@gmail.com	Chattogram	Panchlaish 	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-09 15:48:15.639	2026-06-09 16:40:16.326	\N	\N	0	\N	f	ONLINE
cd9b3a13-ee84-47c3-8651-fd6cc03bad17	\N	\N	3420271	s.m shehab	01748818279	Tolarbagh 2 number get care Academy school er shamne house number 9/6		smshehab1239@gmail.com	Dhaka Mirpur 1 	Tolarbagh 2 number get care Academy school er shamne house number 9/6	1	2000	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-09 17:34:00.768	2026-06-09 17:41:37.354	\N	\N	0	\N	f	ONLINE
c4c68d75-a56c-401a-b9eb-6e72e2e6e527	\N	\N	0548281	Siam Khan	01409692694	Baitul Aman		chatgt92929@gmail.com	Faridpur	Baitul Aman Bazar	1	2000	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-11 07:15:45.6	2026-06-11 09:45:41.28	\N	\N	0	\N	f	ONLINE
4c7c66d2-8d42-4430-8f57-f90a0a42c44a	\N	\N	9732581	Mahabub Murshed 	01845152722	482-West Shewrapara Mirpur Dhaka -1216		murshedmahabub46@gmail.com	Dhaka	Shewrapara Mirpur Dhaka-1216	1	1700	2150	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-11 08:03:53.566	2026-06-11 09:45:49.988	\N	\N	0	\N	f	ONLINE
32d52f41-8ea2-4d3e-9e2a-7ccc36254443	\N	\N	2043050	Md Tahsan Masud	01888683476	House 13C/D, Road 15, Block G		its.tahsan.here@gmail.com	Dhaka, Bangladesh	HOUSE 13C/D, ROAD 15, BLOCK G, BASHUNDHARA R/A, DHAKA 1229	1	1200	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-11 15:43:47.252	2026-06-12 19:09:25.437	\N	\N	0	\N	f	ONLINE
b5ec7da3-a3a3-4292-b549-d451995577ea	\N	\N	7274160	Tanjim Ahmed Tanmay 	01632150504	??????????????????????????? ???????????????, ??????????????????????????? ??????????????????, ????????????????????? ???		tanjimtanmoy647@gmail.com	Gazipur 	kaliakair	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-12 06:47:06.691	2026-06-12 19:09:35.497	\N	\N	0	\N	f	ONLINE
309a4090-6769-49e9-a5f1-24f73b65e406	\N	\N	5766711	alom	01747498604	orchid point			Dhaka	Bashabo	6	7900	9170	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-12 20:20:21.727	2026-06-13 18:16:39.054	\N	\N	0	\N	f	ONLINE
424133dc-ebe8-4e1a-b142-b1be0e832dcd	\N	\N	5121300	Imo	1309850420	Mirpur.2 mosjid market pizzaburg			Dhaka 		1	1400	2820	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-08-09 22:12:19.563	2026-08-10 00:09:58.611	\N	\N	0	\N	f	ONLINE
16e92e66-330f-4472-a754-70a2c9b013d8	\N	\N	3757010	Rony	01315560387	Kaliyakur		r73390304@gmail.com	Dhaka 		1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-11 09:44:46.462	2026-08-12 07:22:45.652	\N	\N	0	\N	f	ONLINE
ff112442-3b83-4c1a-b729-a9d762c8088c	\N	\N	0320671	Aryan Bhagat	9322482199	Aryan Bhagat B 102 ,Centurian Park Chinchpada PEN, MAHARASHTRA 402107 India Phone number: ???9322482199???		aryanbhagat0306@gmail.com	Raigad	Pen ,raigad , Maharashtra 	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-14 07:46:25.44	2026-06-15 08:49:19.571	\N	\N	0	\N	f	ONLINE
12768994-1798-4f43-9b20-a63a771ee4ab	\N	\N	7840061	Arya Hebbar	91410 89707 	Puttana Road basavanagudi bangalore 		hebbararya07@gmail.com	Bangalore 	Vadiraja nilaya door no 20	1	1200	1120	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-14 16:00:54.351	2026-06-15 08:49:25.357	\N	\N	0	\N	f	ONLINE
52b94829-6ff0-401a-8190-4562e5837949	\N	\N	3890821	Robiul Islam Ashik	+880 16 7817 4130	Flat 1B Toma Waterlily  14/3/B Sadek Khan Rd, Rayerbazaar, Dhaka		robiulislamashik9@gmail.com	Dhaka	Mohammadpur	1	1700	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-14 16:27:47.841	2026-06-15 08:49:29.998	\N	\N	0	\N	f	ONLINE
b4fa9aeb-4d3a-4b20-8100-95dae1727573	\N	\N	3815641	Yasin	01521535746	C block,162,mir bhabon			Chittagong 	Boro mia mosjid,R/A c block mir bhabon,chawkbajar 	1	1200	920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-14 16:11:15.521	2026-06-15 08:49:35.049	\N	\N	0	\N	f	ONLINE
8c8a77ae-f187-4e97-a5a5-ef04ccb00502	\N	\N	8095161	M Kaif Ali Rayan	01648353408	23, Allama Iqbal Road, Narayanganj-1400		kaifalirayan0@gmail.com	Narayanganj 	Narayanganj 	1	1700	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-15 18:07:56.217	2026-06-15 18:32:59.811	\N	\N	0	\N	f	ONLINE
6fd26de4-da8b-4c31-b7dd-10d21ccfe071	\N	\N	5370610	Rafi Hasan	01991582002	flat a2 house 14 road 1 block d kaderabad housing dhaka 1207		rafi6841@gmail.com	dhk	dhk	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-15 18:02:31.467	2026-06-15 18:33:04.568	\N	\N	0	\N	f	ONLINE
54c447b3-3416-4728-b185-c8852d8bec0c	\N	\N	7499981	Owais Rabban	01791265317	Avenue 4 road 4 house 139			Dhaka	Mirpur dohs	1	2000	2600	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-15 12:50:05.356	2026-06-16 11:09:08.567	\N	\N	0	\N	f	ONLINE
d55c4784-eae9-48c8-8cac-10de3b5d1af0	\N	\N	4313571	Md Sakir Dhali	01402236351	Coca-Cola,Dhali bari kacha bazar vatara ,Dhaka 			Dhaka 	Coca-Cola,Dhali bari kacha bazar ,vatara ,Dhaka 	1	1500	2190	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-15 16:55:14.459	2026-06-16 11:09:14.204	\N	\N	0	\N	f	ONLINE
0e9bb824-9cd8-4bea-9fd9-cb8255cd918a	\N	\N	6298651	Shanjir	01713007180	165 Shantinager sky view park city Flat C9		shanjirmahmudkhan1@gmail.com	Dhaka	Shantinager	1	3500	4720	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-15 19:45:30.112	2026-06-16 14:05:28.2	\N	\N	0	\N	f	ONLINE
6f37ccf6-d7d8-4533-aa0b-def6ec655b64	\N	\N	2646870	Riyad  khan 	01926166712	Noton bazar 			Kishoreganj 	Thana Nikli 	1	1200	920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-16 10:39:51.362	2026-06-16 19:13:58.412	\N	\N	0	\N	f	ONLINE
601e279b-2203-497e-a33b-f55800e5a2b2	\N	\N	7040180	Arafat	01799741452	CB - 241, Puran Kachukhet, Dhaka Cantonment, Khaza Garments er goli, Dhaka 1206			Dhaka	Kafrul Thana	1	2000	2600	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-16 12:09:59.667	2026-06-16 19:14:02.795	\N	\N	0	\N	f	ONLINE
4c0922e7-8b80-4225-a226-a81aeed0925c	\N	\N	9193531	Md milon	01829-225099	Sonapur,  posu hospital road, mohobbatpur			Noakhali	Mohobbatpur, sada math	1	2000	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-16 12:53:46.623	2026-06-16 19:14:07.393	\N	\N	0	\N	f	ONLINE
dfa8ef9f-68f2-4437-be81-85435f9835ba	\N	\N	2472070	Sakib	01336764464	 seba city centar		shakibhossain2369@gmail.com	Chandpur sadar	Chandpur sadar	1	2000	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-16 16:11:58.556	2026-06-16 19:14:12.99	\N	\N	0	\N	f	ONLINE
e616dd2f-ae01-43f8-8134-8ead77d8cc19	\N	\N	3080880	Fariha Rowshon 	01715437185	Flat B2 Navana Faizan Hights Shohid Mirza lane Mehedibag 		fariharowshon@gmail.com	Chittagong 	Mehedibag 	1	1200	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-16 17:53:08.209	2026-06-16 19:14:17.655	\N	\N	0	\N	f	ONLINE
dd1df205-31be-4834-a855-57c302a0fe9f	\N	\N	9976881	Syed Ahnaf Jawad	01960588818	8/3 Block #C Flat A5		darkahnaf772@gmail.com	Dhaka	Lalmatia	1	1500	1230	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-17 06:18:19.294	2026-06-17 20:18:44.875	\N	\N	0	\N	f	ONLINE
9b6125d2-c908-4a53-8cc1-d548be9483b6	\N	\N	3283001	rakib	01795690031	taltoli			Barguna	taltoli Bazar	1	1500	1270	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-18 08:12:58.735	2026-06-18 09:34:41.408	\N	\N	0	\N	f	ONLINE
01c6aeee-a81d-4324-ba25-ca426afe003d	\N	\N	8221840	Tanvir 	01770177227	Nagari,kaligonj,gazipur 		tanvirhassan817@gmail.com	Gazipur	Nagari,kaligonj,gazipur 	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-18 09:12:27.97	2026-06-18 09:34:47.988	\N	\N	0	\N	f	ONLINE
091c170a-e2d8-46ec-a707-d3f9a25f6517	\N	\N	5919321	Abir ahmed	01336684158	Khilgoan sipaibag bazar		rdxpk65@gmail.com	Dhaka	Khilgaon sipaibag 	1	3500	5280	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-18 19:40:34.748	2026-06-18 20:45:17.909	\N	\N	0	\N	f	ONLINE
8ebe65dd-d49b-4f31-b99c-ed31f0b4eabd	\N	\N	1964030	Niloy 	01629951560	Bogura sadar bogura 		niloyniyaz1429@gmail.com	Bogura sadar 	Namazgor vandari mosque 	1	1500	1270	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-19 13:04:18.565	2026-06-19 13:31:16.164	\N	\N	0	\N	f	ONLINE
c1077061-3e64-4413-938d-3fbb1f4c770c	\N	\N	6624290	KI Sifat	1844169200	379 free school street Hatirpool pukuroar		Sifat.org@gmail.com	Dhaka	Dhanmondi	1	3500	4480	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-19 11:48:59.279	2026-06-19 13:31:20.653	\N	\N	0	\N	f	ONLINE
6b381482-dcfb-4551-bef2-582211a5300d	\N	\N	0003020	Mahbub 	01629334442	242/A,papergoli kathalbagan free school street  (bliss Bangladesh building)		mahbubekhoda98@gmail.com	Dhaka	 Kathalbagan 	1	1000	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-19 17:45:13.37	2026-06-19 22:21:57.821	\N	\N	0	\N	f	ONLINE
8c34cd1b-9678-472b-b73f-8c7ae08bddee	\N	\N	8660980	Md Tanvir	01830562829	Borophul,agrabad, kazi office building 		mdt716548@gmail.com	Chattogram 	Chittagong 	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-19 18:15:09.465	2026-06-19 22:23:49.943	\N	\N	0	\N	f	ONLINE
92b6ab4b-4fb0-44e4-89a7-ea4f4b6cd16a	\N	\N	5503960	Rumman Ahmed 	+8801778834437	Sui Sutha Store,  Dhak-Bangla Road, Barlekha, Moulvibazar			Moulvibazar 	Sui Sutha Store,  Dhak-Bangla Road, Barlekha, Moulvibazar. 	2	7000	8920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-19 14:16:57.533	2026-06-19 22:34:59.853	\N	\N	0	\N	f	ONLINE
74730e2b-1cf8-49c4-bb1b-27aed0114279	\N	\N	2927411	Shahrukh shiplu	01782367281	postoffice road, Moheshpur, jhenaidah 		ShahrukhShiplu@gmail.com	Jhenaidah	Bazarpara, postoffice road, Moheshpur, jhenaidah 	1	3500	4520	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-20 04:05:40.935	2026-06-20 08:11:47.05	\N	\N	0	\N	f	ONLINE
05a1ded6-8cd7-42e3-84ca-9c34a0f109fc	\N	\N	8431711	Samiha Raisa	01680062117	Hadi Tower, Road# 50, Gulshan 2		raisa.anika1029@gmail.com	Dhaka	Gulshan 2	1	1700	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-20 07:52:00.899	2026-06-20 08:24:23.5	\N	\N	0	\N	f	ONLINE
e1e280fe-ceb3-45db-b5bd-4bae31e7cf81	\N	\N	9388211	Shafiul Azam Azam	01844115115	Jamuna Bank Tower Head Office Gulshan-1 Dhaka		jam.shafi@yahoo.com	Dhaka		1	3500	4480	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-20 09:14:17.254	2026-06-20 11:20:44.55	\N	\N	0	\N	f	ONLINE
2694c883-750d-4162-8d80-1229b164ed96	\N	\N	9000270	Lodi	01671519477	18 Nasiruddin sordar lane 		tanvir.lodi@yahoo.com	Dhaka Sutrapur 	18 Nasiruddin sordar lane 	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-20 17:03:34.304	2026-06-20 19:13:06.368	\N	\N	0	\N	f	ONLINE
9303f0c5-36a3-4f5b-a227-c011b24a458a	\N	\N	7023261	Mohammad Nayan Ahmed	01805746929	?????????????????????????????????, ??????????????????????????????		nayannome200096@gmail.com	Comilla	Comilla cantonment	1	3500	4520	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-20 15:36:56.782	2026-06-20 19:17:48.913	\N	\N	0	\N	f	ONLINE
bf324fed-9754-4552-92dd-ee7aa4f75013	\N	\N	6325570	Fuad Hossain 	01646260230	Brahmanbaria Nasirnagar Horripur		fuadhossain319@gmail.com	Brahmanbaria 	Brahmanbaria Nasirnagar Horripur	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-20 18:04:58.852	2026-06-20 19:19:17.947	\N	\N	0	\N	f	ONLINE
b814968c-6edb-4be0-922a-3ccf4960fb20	\N	\N	2497490	Syed Tawfique Mahmud	+8801748000204	109/A, Kazi Office Lane,Ramna,Dhaka-1217		syedtawfiquemahmud21@gmail.com	Dhaka 	Ramna,Dhaka	4	12700	17170	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-20 19:38:43.257	2026-06-21 07:45:15.854	\N	\N	0	\N	f	ONLINE
c3478bff-87cc-4d48-9a5d-a82591b308d5	\N	\N	0750111	Imtiaz Chowdhury 	01739646964	Business 48, Level - 7, Plot No - 48, Block - F, Banani 11, Dhaka.			Dhaka	Banani	1	3500	4480	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-21 03:23:26.843	2026-06-21 07:53:55.938	\N	\N	0	\N	f	ONLINE
8ddc4101-866b-413f-8f92-6add69fea179	\N	\N	8241890	Md Safayet Hossain 	01631567196	Daffodil international University 		safradon5@gmail.com	Dhaka 	Birulia, Savar	1	1700	2190	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-21 06:24:09.452	2026-06-21 07:55:54.737	\N	\N	0	\N	f	ONLINE
7d39eb40-32a4-497c-9ecc-3f7fb2a1a4d9	\N	\N	5957241	sagor Ahmed Khan 	01836309314	Block d road 2 Bosundhora 		ahmedshagor377@gmail.com	Dhaka 	Dhaka 	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-21 07:25:47.393	2026-06-21 10:23:00.254	\N	\N	0	\N	f	ONLINE
7696b861-68b1-4f2a-bd3f-8ce2d8930082	\N	\N	2328251	Shafiul Azam Azam	01844115115	Jamuna Bank Tower Head Office Gulshan-1 Dhaka		jam.shafi@yahoo.com	Dhaka	Dhaka	1	3500	4480	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-21 11:44:48.802	2026-06-21 12:41:06.99	\N	\N	0	\N	f	ONLINE
426b489f-3e14-4ed2-80ab-223207c3a73b	\N	\N	0300751	Nushrat 	+8801741044704	Sector 10 road 12 house 35 		zahannushrat05@gmail.com	Dhaka 	Uttara 	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-21 12:15:49.289	2026-06-21 12:45:26.399	\N	\N	0	\N	f	ONLINE
ca9a4b4c-3bdb-4a3c-a792-a26697da731c	\N	\N	1468840	DRS Sumon	+8801776538875	Top-6 Goplar Bazar 		drssumon24@gmail.com	Habiganj 	Goplar Bazar nabiganj 	1	1500	2190	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-21 16:09:52.577	2026-06-22 08:27:53.234	\N	\N	0	\N	f	ONLINE
be49e4f8-e54f-49f5-bd3d-e849cbd11231	\N	\N	3852941	Miskat 	01690069721	Halishahar soltgola railway crossing eshak sowdagor bari 		gaylemiskat@gmail.com	Chittagong 	Chattogram bandar	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-22 18:05:15.39	2026-06-23 08:05:12.869	\N	\N	0	\N	f	ONLINE
8007c6e6-12a4-4e4a-84c1-11432a6726e7	\N	\N	8759720	ashiyan islam	01785814742	bangladesh national museum 		ashiansadh99999@gmail.com	dhaka	shahabag moore	1	1700	2600	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-23 06:29:02.736	2026-06-23 08:05:55.511	\N	\N	0	\N	f	ONLINE
ee0be70a-6672-446d-a3fc-1a038ec712cc	\N	\N	3268430	01879737777	+8801879737777	Sector 08 polowel carnetion 		mmjamim.m4autis@gmail.com	Dhaka 	Uttara 	1	3500	5320	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-23 07:06:42.004	2026-06-23 08:06:51.409	\N	\N	0	\N	f	ONLINE
05a7b668-7b83-4e68-a491-22beb000f838	\N	\N	8498790	MD IMAMUL HASAN	01999914788	House -428, Senpara Parbata, Mirpur BRTA, Dhaka-1216		emamulhassanemu007@gmail.com	Dhaka	Dhaka	1	1700	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-23 07:48:36.077	2026-06-23 08:07:01.44	\N	\N	0	\N	f	ONLINE
a09fc3a2-afda-4b2a-849f-92416b07a2c7	\N	\N	2062180	Muneeb	01577141823	Taltola road near parkview medical collage		syedfahad4800@gmail.com	Sylhet	Taltola	1	1200	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-23 08:44:16.429	2026-06-24 09:59:56.451	\N	\N	0	\N	f	ONLINE
1082f129-ac4d-4ed2-8028-b8e4f25429c1	\N	\N	3886560	Jannatul kefayat	+8801764053638	Flat C9, house 94, road 23, block A banani 		jkefayat26@gmail.com	Dhaka 	Banani 	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-23 11:17:48.371	2026-06-24 10:00:41.957	\N	\N	0	\N	f	ONLINE
56478028-780f-43a9-92ed-e56900d282ce	\N	\N	0853690	Fatema Ahsan	01752660011	House 21 Road 7 Block F		fwahsan.p@gmail.com	Dhaka	Banani	1	1700	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-23 20:38:40.229	2026-06-24 10:03:24.737	\N	\N	0	\N	f	ONLINE
6463255c-5b16-4558-81e6-3d5d21176cad	\N	\N	7345851	Md Rupok Hossain	01791379655	Abdul Aziz Shorok, Bashundhara, Dhaka			Dhaka	Abdul Aziz Shorok, Bashundhara, Dhaka	1	1500	2150	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-24 11:33:27.276	2026-06-24 11:50:34.673	\N	\N	0	\N	f	ONLINE
5c93e43c-26bc-44f7-9483-d950974a5311	\N	\N	0540280	Anurup sarkar	1840282493	???/111/5/A Niketon bazar Gulshan		anurupsarker493@gmail.com	Dhaka	 Niketon bazargate, Gulshan	1	4000	5280	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-23 18:58:32.725	2026-06-24 11:50:41.702	\N	\N	0	\N	f	ONLINE
75383884-ed6a-44a1-9ead-0fd78a092926	\N	\N	9037360	Faisal Newaz Pavel	01955502400	Nrbc Bank Principal Branch 114 Motijheel C/A Dhaka		fnpnewaz@gmail.com	Dhaka	Nrbc Bank PLC, Principal Branch, 114 Motijheel C/A, Dhaka	1	1500	1230	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-24 14:56:44.563	2026-06-25 09:10:43.022	\N	\N	0	\N	f	ONLINE
69d4a63a-02ae-4734-8ded-a4357c39efd4	\N	\N	2903730	mominur	01622001228 	?????????????????? ?????????????????? ???????????????????????? ?????????????????????????????? ?????????????????? ?????????????????? ???????????? 			Dhaka	Dhamrai	1	1000	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-25 03:15:21.184	2026-06-25 09:12:08.943	\N	\N	0	\N	f	ONLINE
3ee81f09-2a98-424d-a567-3741b77c3856	\N	\N	4425341	Al-amin	01688665697	Pioneer diagnostic centre,ukilpara,Sunamganj sadar		alamin.somc51@gmail.com	Sunamganj	Pioneer diagnostic centre,ukilpara,Sunamganj sadar	1	1200	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-25 09:09:31.056	2026-06-25 09:13:46.789	\N	\N	0	\N	f	ONLINE
baf47fed-9694-42d1-b8d9-9c84af891326	\N	\N	9543010	Akash 	01301511670	Babu Bazaar 		akashtss14@gmail.com	Dhaka 	Babu Bazaar Ali points dhaka - 1100	1	1200	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-25 08:44:44.633	2026-06-25 09:27:36.241	\N	\N	0	\N	f	ONLINE
a131d86b-b506-4bbc-b34d-f5b144852d52	\N	\N	3774271	Shahe Imran Roni	+8801601700237	Banasree Block-C Road-4 House-15 Floor-602		shaheimranroni306@gmail.com	Dhaka	Banasree Block-C Road-4 House-15 Floor-602	1	1500	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-24 22:02:22.523	2026-06-25 17:49:49.359	\N	\N	0	\N	f	ONLINE
8ca5ebed-13d4-40bb-920c-6346575d4545	\N	\N	4709041	Asadullaha al Galib	01760402414	Aftab uddin complex		aagalib7@gmail.com	Munshigonj 	Secret taste , aftab uddin complex , Munshiganj shodor	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-25 12:29:03.073	2026-06-25 20:08:54.428	\N	\N	0	\N	f	ONLINE
4d2b3b4b-857b-4fd1-b22b-eda792783e77	\N	\N	4462691	Papon	1705297963	Rajshahi city		ipapon555@gmail.com	Rajshahi 	Rajshahi city tikapara 	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-25 11:04:43.792	2026-06-25 20:09:00.544	\N	\N	0	\N	f	ONLINE
1040aaa5-75ce-4c49-aa1b-80e48a850014	\N	\N	3821241	Hridoy Rahman	1792100501	Naria Bhojesshor Mosura shariatpur 		hridoyrahman0000@gmail.com	Shariatpur 	Mosura 	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-25 19:24:06.971	2026-06-25 20:13:47.528	\N	\N	0	\N	f	ONLINE
142e9044-83d3-43db-b339-cb0a5a80b8bb	\N	\N	9131391	Dr. PoLash HussAin	+8801618220351	Firujpur Road-3, Lawai, South Surma, Sylhet		hussainpolash005@gmail.com	sylhet	firujpur road 3, lawai, south surma	1	1500	1270	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-26 02:13:03.519	2026-06-26 08:40:31.855	\N	\N	0	\N	f	ONLINE
dffb54a8-7df2-4d77-9ae3-ee2da6d31bd6	\N	\N	1639170	Jasrat	01780355108	24/8 Tajmahal road opposite of japan garden city, Mohammadpur, dhaka		jazzamir07@gmail.com	Dhaka	Mohammadpur,Dhaka	1	1500	1330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-26 06:10:53.153	2026-06-26 08:26:12.966	\N	\N	0	\N	f	ONLINE
7e2e669e-fd22-408c-a6be-ad894a926e7b	\N	\N	4263221	Shojol Ahmed	01408967220	Middle arichpur nekarbari,tongi,gazipur		sanvirahman526@gmail.com	Gazipur	Tongi	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-26 05:42:12.112	2026-06-26 08:28:51.246	\N	\N	0	\N	f	ONLINE
0c7ee660-a68f-4dc4-af8c-5933e9acc984	\N	\N	0068611	Dr. PoLash HussAin	01618220351	Firujpur Road-3, Lawai, South Surma, Sylhet		hussainpolash005@gmail.com	Sylhet 	firujpur road 3, lawai, south surma, sylhet	1	1500	1270	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-26 02:14:12.298	2026-06-26 08:40:27.189	\N	\N	0	\N	f	ONLINE
871f3aa9-f76b-4be1-82d3-7610158bb5f3	\N	\N	5833310	Badhan Kar	+8801319772141	Uttara dhour turag puran thana sdc traning center 		badhankar6@gmail.com	Dhaka 	Uttara dhour turag puran thana sdc traning center 	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-26 10:27:50.446	2026-06-26 12:19:30.296	\N	\N	0	\N	f	ONLINE
3d4d85b6-74b1-4bed-a137-1712f641e4a6	\N	\N	8154320	Rifat	01841164430	Baburail notun rasta		rifat.hossain.0987@gmail.com	Dhaka 	Narayanganj cashara Baburail 	1	1000	1740	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-28 03:06:27.476	2026-06-28 09:13:26.101	\N	\N	0	\N	f	ONLINE
0fe46619-ae06-4cba-a42a-93bbcd90d1b6	\N	\N	5874401	Humairah Hoque Siddique	01711183199	House-46, Road-2, Shekhertak, Mohammadpur-1207, Dhaka		humairahhoque@gmail.com	Dhaka	Mohammadpur 	1	1700	1330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-26 10:44:55.686	2026-06-26 12:19:42.414	\N	\N	0	\N	f	ONLINE
8c9c962e-a94c-4d51-8d63-800df22c1804	\N	\N	1063311	Saiful Alam Khan	01730310851	260/B Tejgaon I/A dhaka		shipusania011@gmail.com	Dhaka 	Tejgaon dhaka	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-28 04:16:44.222	2026-06-28 09:13:31.043	\N	\N	0	\N	f	ONLINE
7e9e412d-93af-44a2-b601-11e69a8a2983	\N	\N	9737151	zareef	01750529928	mirpur 12 block A road 2/1 house 149		zareefmahmud5@gmail.com	dhaka	mirpur 12 block A road 2/1 house 149	1	1000	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-27 06:34:12.833	2026-06-27 08:57:23.872	\N	\N	0	\N	f	ONLINE
df05c6ae-d013-46d3-b7ad-4da906ff7ee7	\N	\N	3855440	Rifat 	+8801843279381	Belkuchi shirajganj 		mdrifat4049@gmail.com	Shirajganj 	Belkuchi shirajganj 	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-26 14:17:23.484	2026-06-27 08:58:56.628	\N	\N	0	\N	f	ONLINE
eb5c7ff7-218e-434e-86ae-ade99ae079ed	\N	\N	2273251	Ahmed Shahriar	01795731321	House No 17 Road 5 Dhanmondi		shahriarmails696@gmail.com	Dhaka	Dhanmondi 	1	1500	1330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-26 13:41:04.306	2026-06-27 08:59:54.795	\N	\N	0	\N	f	ONLINE
943ff660-7288-474b-8c6b-eadfb00538b3	\N	\N	6648171	Tahmid Hoque	01882069096	 Haji Nurul Hoque shoudagor baari, dewan bazar bhora pukur paar, west bakalia, chawkbazar, chattogram  		tahmidhoq7820@gmail.com	Chittagong 	Chittagong 	1	1500	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-26 12:09:09.815	2026-06-27 09:00:58.019	\N	\N	0	\N	f	ONLINE
eb658730-630b-47f3-aed8-8ddf1bd2eb0a	\N	\N	6844460	Tajbid Meraj	01886725563	Bashundhara, block H, road 2, house 692		tajbidmeraj017@gmail.com	Dhaka	Bashundhara 	1	1700	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-27 11:46:23.863	2026-06-27 19:48:39.772	\N	\N	0	\N	f	ONLINE
c7b4d81b-91ea-4098-a331-2b744334c849	\N	\N	0130320	Anuj	+917058290982	E-804,sukhwani pacific , thergaon, pune 411033		anujsutar18@gmail.com	Pune	Pune	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-27 18:30:59.179	2026-06-27 19:48:44.785	\N	\N	0	\N	f	ONLINE
bce269b7-f159-45da-bb03-97b37c2b7829	\N	\N	6171521	Robey Ahmed	01711107560	Flat 1F, House 10, Road 15, Dhanmondi		nivanyeamin@gmail.com	Dhaka	Dhanmondi	1	1700	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-28 04:41:38.434	2026-06-28 09:13:35.946	\N	\N	0	\N	f	ONLINE
540a0b34-4302-4731-8284-9870ac99be38	\N	\N	6212141	Shahriar Khan 	01336889044	South alekanda, Nuria school er pichon e, Barishal 		passionate641@gmail.com	Barishal	South alekanda, Nuria school er pichon e, Barishal 	1	1000	1920	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2026-06-28 11:57:45.149	2026-06-28 11:57:45.149	\N	\N	0	\N	f	ONLINE
ae067969-8f89-448e-a5c6-7ef067a757a8	\N	\N	1239690	Masudul Hasan	01727677015	Faruk Chamber, 1403, Sk Mujib Road, Agrabad C/A, Chattogram		masudcuet93@gmail.com	Chattogram 	Double Mooring	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-28 11:29:58.896	2026-06-28 12:00:00.176	\N	\N	0	\N	f	ONLINE
353e491b-c4db-46dd-b69c-fd00e254db42	\N	\N	3255300	Dandiram asif thakur 	01741688308	Soriatpur bording, gowalondo bus stand,  Rajbari district 			Rajbari 	Gowalondo 	1	1500	2190	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-06-28 19:53:09.968	2026-06-28 20:20:12.37	\N	\N	0	\N	f	ONLINE
fd3ed5ac-ac20-415d-8f2f-e0d04e5cbd34	\N	\N	6517410	Tanjim	01540550615	Kamarpara near by puraton turag thana		hossain424399@gmail.com	Dhaka	Dhaka	1	2000	2600	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-28 17:12:37.604	2026-06-29 11:47:41.276	\N	\N	0	\N	f	ONLINE
8f467403-3787-4481-8131-07d8b279f1fa	\N	\N	4269070	Pony	01811591986	Aganowab deaury		neeljocna@gmail.com	Dhaka	Lalbagh	1	1000	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-29 00:05:30.581	2026-06-29 11:48:39.32	\N	\N	0	\N	f	ONLINE
55eec2cf-5aa6-46aa-a29a-0367d942bbc2	\N	\N	3831591	Rabby Khandaker 	01907188769	Basail-1 (??????????????????-???),Narsingdi Sadar Narsingdi 			Narsingdi 	Narsingdi Sadar	1	1700	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-29 04:14:30.886	2026-06-29 11:49:35.107	\N	\N	0	\N	f	ONLINE
0ad5a67b-eff8-4ad0-98ae-7fafb5d041a9	\N	\N	0918741	Fardin Hossain Siam	+8801963976430	tikatuli k.m das lan (dewanbari)		fardinhossainsiam0@gmail.com	dhaka	tikatuli	1	1700	2150	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-29 04:27:49.269	2026-06-29 11:50:38.937	\N	\N	0	\N	f	ONLINE
1b707887-cf88-46c9-8642-7340a5d4dcaa	\N	\N	5422880	Tanvir Islam	01621504243	61, Bijoynagar Panir Pamp, Eastern Arzoo Complex, Lavel 2 Room 6 		iamtanvi101@gmail.com	Dhaka	Paltan, Dhaka - 1000	1	1200	1080	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-29 10:39:51.755	2026-06-29 11:58:40.861	\N	\N	0	\N	f	ONLINE
0f3ed745-5aad-48d9-b73f-5dfb602bc08a	\N	\N	3007181	Imo Imo	1309850420	Mirpur.2 mosjid market pizzaburg		01309850420	Dhaka	Mirpur.2	1	1400	2780	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-08-09 22:09:37.881	2026-08-10 07:42:26.54	\N	\N	0	\N	f	ONLINE
fdd5124c-1397-4b64-a405-696d6b69f37f	\N	\N	8922700	Saif Nazmul	01612069141	Raynogor point, near mirabazar, Sylhet Sadar 3100		saifnazmul007@gmail.com	Sylhet Sadar	Raynogor point, near mirabazar, Sylhet Sadar 3100	1	1500	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-29 16:35:50	2026-06-29 20:16:28.505	\N	\N	0	\N	f	ONLINE
3575867c-084b-4928-8a40-80e716497efc	\N	\N	7496371	Mahmudul hasan	01611918938	BRTC shopping complex station road bogura		mithonrafan0393@gmail.com	Bogura	BRTC shopping complex station road bogura	1	1500	2190	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-29 18:30:15.614	2026-06-29 20:18:09.895	\N	\N	0	\N	f	ONLINE
add76573-9443-4ba0-b665-e2f43d44eb29	\N	\N	6053570	Ratul Mirzza	01402525993	Ayla mirzza home 		ratulmirzza25@gmail.com	Kishorganj 	Kishorganj korimganj 	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-29 16:13:56.081	2026-06-29 20:20:57.647	\N	\N	0	\N	f	ONLINE
5f700012-5d5c-44fb-a7a0-98abe4d85b01	\N	\N	4780081	Thahmid Anas	01334223354	Barlekha, Moulvibazar 		thahmid.anas@gmail.com	Moulvibazar 	Barlekha , Moulvibazar 	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-29 16:11:47.559	2026-06-29 20:22:28.641	\N	\N	0	\N	f	ONLINE
ac8aed89-f121-4277-9c17-bb09f54afef4	\N	\N	5316611	Md Borhan	01620032044	Chittagong roed shop 32 			Narayanganj 	Chittagong roed siddorgonj 	1	1500	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-29 13:43:11.857	2026-06-29 20:23:56.574	\N	\N	0	\N	f	ONLINE
7153fce7-9968-444c-9d78-b88edf2d5619	\N	\N	7129310	Ivan Mashruf 	01908333075	34/2 Shuklal Das Lane, Kagojitola, Sutrapur, Puran Dhaka		mashrufivan@gmail.com	Dhaka	Puran Dhaka, Sutrapur	1	1500	2150	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-30 08:56:21.214	2026-06-30 09:58:53.441	\N	\N	0	\N	f	ONLINE
4a71f58b-986b-4513-ba9d-675e6aa6f00e	\N	\N	8729321	tuheen	01346070990	Konapaea, Shamsul Haq Khan school Road		imonahmeed.tuheen@gmail.com	Dhaka		1	1000	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-30 08:42:25.215	2026-06-30 11:29:49.899	\N	\N	0	\N	f	ONLINE
456fbbf9-a836-4803-88bc-08e2651d2cfa	\N	\N	3079091	Zosim Uddin	01575603542	Flat A-206, Aparajita  Rd. No. 3, Block A Sector 18, Uttara Dhaka-1230		mu878393@gmail.com	Dhaka 	Uttara	1	2000	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-30 15:47:16.508	2026-06-30 20:17:31.53	\N	\N	0	\N	f	ONLINE
4ee31198-a244-4511-a6c4-85b6f26e372e	\N	\N	2200741	Bijoy hossain	+8801326558013	Aualgari 			Joypurhat 	Akkelpur 	2	3700	4890	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-06-30 19:37:41.672	2026-06-30 22:37:10.286	\N	\N	0	\N	f	ONLINE
a37fa903-3670-4d28-be94-347a4041e9cf	\N	\N	6574601	Zaki	01775640436	8/2 Block D lalmatia dhaka 1207		Ishtiaquezaki811@gmail.com	Dhaka	Lalmatia, Dhaka	1	1200	1080	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-06-30 20:51:59.679	2026-06-30 22:37:15.262	\N	\N	0	\N	f	ONLINE
1e81917b-88af-49a8-82ab-1385f5968acd	\N	\N	3697261	Shishir	01608074010	Opposite of shawarma dmascoo,Road 6 Block E 		ontu.40994@gmail.com	Dhaka	Banasree	1	1500	880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-01 06:15:26.166	2026-07-01 07:34:16.714	\N	\N	0	\N	f	ONLINE
42226e77-5b81-492b-b442-b37574cdb1ae	\N	\N	6811481	Priyanshu Tiwari	01708520444	Exim Bank, Floor-12, Modhumita Plaza Concord, Road No. 11, Block-G, Above Richman shop, Banani, Dhaka			Dhaka 	Banani, Dhaka	2	3400	4620	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-01 04:23:50.049	2026-07-01 07:37:18.757	\N	\N	0	\N	f	ONLINE
21a7b546-4487-4dad-829d-5f10bf88e7bf	\N	\N	5338140	Maish	01798355555	House 63, flat 7b, road 5, dohs banani		mobarshira.a@gmail.com	Dhaka 	Banani dohs	1	2000	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-01 02:56:20.874	2026-07-01 08:21:16.072	\N	\N	0	\N	f	ONLINE
2975215c-6221-47f2-9f1c-5dfafbc23af0	\N	\N	2256341	A R Khan Pathan	01789452695	A R Khan Pathan CNG and filling station Hossainpur Netrokona 		rohanpathan2018@gmail.com	Netrokona	Netrokona 	1	1000	1740	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-01 08:08:05.274	2026-07-01 10:20:20.052	\N	\N	0	\N	f	ONLINE
aa334dcc-d017-44fa-b62f-132e345198c4	\N	\N	6146610	Yeakin Ismail	01701260768	Sector 13 road 19 house 35		eakinismail49@gmail.com	Dhaka	Uttara 	1	1200	1080	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-01 10:11:16.251	2026-07-01 10:20:24.445	\N	\N	0	\N	f	ONLINE
15a391c0-db76-4406-8241-2df6746a7359	\N	\N	5642851	Md Hasibul Alom Hemal	01304589577	himel rice ajency Kathgora Bazar Ashulia Savar Dhaka		hasibul.hemal2345@gmail.com	Dhaka	Kathgora Bazar Ashulia Savar Dhaka 	1	1700	2600	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-01 10:27:12.592	2026-07-01 10:53:10.626	\N	\N	0	\N	f	ONLINE
22e51463-4069-4c17-bb6d-33fe3472baa9	\N	\N	2992131	Tahalil Mostafa	01533612664	?????????: ?????????????????? ???????????????????????? ?????????????????????????????????(???????????????????????????????????????) ???????????? ??????: ??????-???/??? ?????????: ??????????????????????????? ?????????????????? ?????????????????????,??? ?????? ?????????,????????????????????????-4000, ???????????????????????????		tahaliltasnif1@gmail.com	Chattogram	Chattogram	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-01 10:40:12.325	2026-07-01 10:59:34.156	\N	\N	0	\N	f	ONLINE
30529980-2cad-4e98-9ced-9f3add232a16	\N	\N	1927001	Saad Arafat	01326064022	K block, Road 12,House 608		saadarafat959@gmail.com	Dhaka	Dhaka	1	1000	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-01 14:13:31.12	2026-07-01 14:22:31.553	\N	\N	0	\N	f	ONLINE
d15c94ac-09ef-4d02-aa55-70d22bce4e1c	\N	\N	0298251	Jibon	01643763678	Khulna boykali 		jibonjibon080808@gmail.com	Khulna	 Khulna Boykali 	1	1500	2820	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-01 17:47:56.47	2026-07-01 18:03:30.463	\N	\N	0	\N	f	ONLINE
ba827405-91f2-4169-9e74-6a370e306054	\N	\N	2493021	Md Fida	1711607110	Damara,konapara,golden bridge,saleha Manzil		mdfida.hossain07@gmail.com	Dhaka	Damra,konapara,Golden bridge,Saleha Manzil 	1	1500	2780	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-01 14:48:55.833	2026-07-01 18:04:36.24	\N	\N	0	\N	f	ONLINE
0a4d727f-f4fb-4c56-b358-09a816f6e5f1	\N	\N	6066170	Emdad Ibn Habib	01755175550	Khalishpur Wonderland park		emdadhabib5@gmail.com	Khulna	N/F-83, Road-210	1	1500	2820	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-01 18:30:40.182	2026-07-01 18:54:57.054	\N	\N	0	\N	f	ONLINE
f520e299-7ec7-4ef3-892c-f88f9d52b396	\N	\N	0733430	Sujon	01911196426	Army quatar 		sujon01718296329@gmail.com	Dhaka 1206	Mirpur 14	1	2000	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-02 08:00:08.355	2026-07-02 10:04:15.654	\N	\N	0	\N	f	ONLINE
889db1b4-571e-4b21-a30b-120be267163a	\N	\N	8638881	Sujon	01911196426	Army colony		sujon01718296329@gmail.com	Dhaka 1206	Mirpur 14 Dhaka 	1	2000	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-02 07:55:50.435	2026-07-02 10:04:20.778	\N	\N	0	\N	f	ONLINE
8068d0d1-20dc-451b-9653-c234bc1a7bcb	\N	\N	6998580	Piyash 	01681960988	Ka-52, Swapnoshiri, North Baridhara 		piyeas.ghos17@gmail.com	Dhaka	North Baridhara	1	2000	1230	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-02 06:46:46.075	2026-07-02 10:05:49.936	\N	\N	0	\N	f	ONLINE
a34827fd-6fea-4218-9283-4f423d479c2d	\N	\N	7328350	Nuras Dewan	01675465696	House 250 road 18 apt 5 new dohs mohakhali 		dewan.nuras@gmail.com	Dhaka	House 250 road 18 apt 5 new dohs mohakhali 	1	1500	2780	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-02 04:49:43.298	2026-07-02 10:06:47.535	\N	\N	0	\N	f	ONLINE
0ef7ce9b-7397-4275-9794-8ce7b877ff49	\N	\N	2326760	Angon	01821603494	Gollapara Bazar,Tanore,Rajshahi 		angon58849ahamed@gamil.com	Rajshahi	Tanore,Rajshahi	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-01 19:49:10.211	2026-07-02 16:26:07.192	\N	\N	0	\N	f	ONLINE
ba53aa12-c492-4c2c-8655-4a572ab06dfa	\N	\N	7054640	Kawsar 	01613821404	Rm cunter Gulshan 2		arkawsar540@gmail.com	Dhaka 	Gulshan 2 Rm cunter 	1	1500	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-03 01:42:16.287	2026-07-03 11:27:56.074	\N	\N	0	\N	f	ONLINE
e47e3f57-6dc6-4e10-8a24-f56398ecdb02	\N	\N	3900160	Anasul	01758869354	ANASUL HAQ AMIN house-347, road-4, baitul aman housing society, adabor, shyamoli Dhaka phone: 01758869354 		anasulhaqamin00@gmail.com	Dhaka	Adabor 4	1	1500	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-03 05:26:58.88	2026-07-03 11:29:10.302	\N	\N	0	\N	f	ONLINE
8a771b30-3291-44f2-84c9-18be39b26532	\N	\N	2321650	kamrul hasan	001950481538	Shisu polli road,Northern 		khtextile60@gmail.com	Gazipur 	Northern, mc bazar, mawna	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-03 07:55:09.168	2026-07-03 11:30:16.176	\N	\N	0	\N	f	ONLINE
89b1c66b-eef0-429a-87ee-290f4cd7c82a	\N	\N	8699241	Jaber	01780955832	H monjil			Noakhali 	H monjil, moddo karimpur school, Choumuhani, Noakhali	1	2000	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-03 10:18:44.899	2026-07-03 11:34:17.994	\N	\N	0	\N	f	ONLINE
521f050a-294e-414e-8c76-c3809e4eea14	\N	\N	0367700	Rafan	01678102121	House 6, road 22, block C, mirpur, section 10		rafan.ahmed.do@gmail.com	Dhaka	Dhaka 1216	1	1700	2600	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-03 13:25:34.521	2026-07-04 18:15:00.917	\N	\N	0	\N	f	ONLINE
2e170499-01af-4171-b12e-26452d265098	\N	\N	6723641	Mehedi Sajin	01731166896	Tusher & ariz kingdom, sayed mridha road, dattapara, Tongi		rafayetsazin54@gmail.com	Gazipur	Tongi	2	2700	4440	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-04 03:36:52.58	2026-07-04 18:15:09.279	\N	\N	0	\N	f	ONLINE
e9b1997a-cb77-4f7d-9daa-123068e28409	\N	\N	6792560	Naimul Islam Janmo 	+8801971790690	House/Holding: 392, Village/Street: Ballabhganj, Ramchandrapur, Post Office Ghoramara-6100, Boalia, Rajshahi City Corporation Corporation, Rajshahi		inaimulislam1000@gmail.com	Rajshahi 	Rajshahi,Tikapara Para,(khuli para)bow bazar 	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-05 08:07:10.814	2026-07-06 10:34:49.456	\N	\N	0	\N	f	ONLINE
fbc1fbe9-c231-4758-a394-5f2693c2608d	\N	\N	5477920	Shipu	01730310851	260/B Tejgaon I/A dhaka		shipusania011@gmail.com	Dhaka	Dhaka	1	1000	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-05 08:36:24.847	2026-07-06 10:34:59.204	\N	\N	0	\N	f	ONLINE
42f01dc4-3915-4735-956e-a934a6a63023	\N	\N	1761030	Sohan 	6361322909	Kuvempu nagar, Tumkur			Tumkur 	Karnataka 	1	1700	2500	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-05 10:44:37.835	2026-07-06 10:35:09.574	\N	\N	0	\N	f	ONLINE
2848536d-02d1-4b2f-803c-93ecdb072d7a	\N	\N	3373901	atiqur Rahman ovi 	01307188415	Bus stand 		atiqurrahmanovi123@gmail.com	Barisal 	Bakergonj 	1	1700	2245	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-05 19:39:55.825	2026-07-06 10:35:18.661	\N	\N	0	\N	f	ONLINE
f62dded2-36bf-4056-837c-d588547f06aa	\N	\N	0692800	Omiyo 	01401992055	Lagolbadh bazer 		anikkumarbiswas2055@gmail.com	Magura 	Sreepur Lagolbadh bazer 	1	2000	2500	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-06 06:09:45.984	2026-07-06 10:35:26.342	\N	\N	0	\N	f	ONLINE
77470fc2-3b68-4ed4-a993-50d11424278f	\N	\N	8877701	Zainab Suhail	+8801798398730	New Girls Hostel,Enam Medical College,Savar,Dhaka		bhattzainabb@gmail.com	Dhaka	Enam Medical College,Savar,Dhaka	1	2000	2460	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-06 07:46:05.07	2026-07-06 10:35:32.903	\N	\N	0	\N	f	ONLINE
8eb83f27-be72-4ea7-8bf0-1be4ad2ddd3a	\N	\N	1209750	Masud rana	01872176501	Lane:i,house:art home		ffirstchoice@gmail.com	Chattogram	West ferozshah colony,lane:i,ak khan,ctg	1	2500	3720	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-06 15:20:44.956	2026-07-06 15:52:27.026	\N	\N	0	\N	f	ONLINE
013ddb6f-53b9-48d1-8b77-20dfc5313e5f	\N	\N	8685350	reza	01685082854	house-114 road -16 sector -14 uttara			Dhaka	uttara	1	2500	3680	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-06 15:49:00.369	2026-07-06 15:58:07.51	\N	\N	0	\N	f	ONLINE
d23639c0-0860-4bf1-bfe0-c4251f80d20c	\N	\N	7728731	rayhan srabon	1911539790	Baitulmukkaram Market		rayhan.srabon168@gmail.com	Dhaka 		1	3500	4520	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-06 19:06:50.25	2026-07-07 18:45:19.876	\N	\N	0	\N	f	ONLINE
a223f006-8075-447f-b4c0-b67e026bcedc	\N	\N	0781501	Rimon Hossen	+8801686868584	3rd floor		rimonlive22@gmail.com	Dhaka	Uttara sector 9 road 3D house 20	1	3500	4480	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-06 19:12:16.712	2026-07-07 18:45:28.682	\N	\N	0	\N	f	ONLINE
bbee05ec-cbc5-4e28-b239-ea33918c1ea4	\N	\N	7245541	Hasan	01886012100	manik nagar balur math pakar matha ps:mugda			Dhaka	manik nagar balur math pakar matha ps:mugda	1	2500	3680	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-07 20:07:10.369	2026-07-07 20:49:06.984	\N	\N	0	\N	f	ONLINE
86a283e6-0f61-4463-ac06-e3aff214d347	\N	\N	6936000	Taki Ibne	01911651814	Sahapur, Dumuriya, Khulna		takiibnamasud@gmail.com	Khulna 	Sahapur Bazar dumuriya Khulna 	1	3500	5320	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-07 16:45:45.551	2026-07-07 20:55:05.345	\N	\N	0	\N	f	ONLINE
5b72a951-0833-4308-b801-88415af58349	\N	\N	2416630	Razu Ahmed	01847790665	Baruihati mor		razuyoungone@gmail.com	Rajshahi	Baruihati, Bhatkhali, Bagmara, Rajshahi	1	1700	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-07 14:59:02.283	2026-07-07 20:55:43.101	\N	\N	0	\N	f	ONLINE
5c4544e5-4458-4a05-87d3-98fbf09635c8	\N	\N	6279831	Md. Mozammel Hossain 	01709639314	Plot#18, gareeb-e-newaz ave, sector -11, Uttara		mozammehossain987@gmail.com	Dhaka 	Plot#18, gareeb-e-newaz ave, sector -11, Uttara 	1	3500	5320	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-07 14:00:09.9	2026-07-07 20:56:27.525	\N	\N	0	\N	f	ONLINE
8df8e853-07f6-45df-8117-0bce4f43c48d	\N	\N	3421121	Nazmul 	+880 15 7750 6088	Chakaria cox'sbazar 		nazmul_raza@yahoo.com	Cox'sbazar 	Chakaria 	1	3700	5320	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-07 13:36:42.679	2026-07-07 20:57:14.093	\N	\N	0	\N	f	ONLINE
73494c1b-e6f5-4501-a615-61b088541aad	\N	\N	4626830	Maruf Morshed 	01797610806	Flat-2/A2, 55, Setu Homes			Dhaka	Flat-2/A2, 55, Setu Homes, Zoo road, Mirpur 1, Dhaka	1	1700	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-07 21:42:28.103	2026-07-07 21:46:44.564	\N	\N	0	\N	f	ONLINE
2b2a28a5-2401-42d5-8bcc-0b95af65df53	\N	\N	7463410	Mahbubul Islam Rahim 	01771223693	Boro Baturpar, Tetli, Daksin Surma, Sylhet 			Sylhet 	Boro Baturpar, Tetli, Daksin Surma, Sylhet 	1	1500	1040	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-08 00:18:27.099	2026-07-08 07:51:09.301	\N	\N	0	\N	f	ONLINE
f47d234e-bbd7-4fcb-8223-bfa85d8ea4e3	\N	\N	4010690	Kakon chakma 	01894852335	Montola road		kakonchakma1@gmail.com	Rangamati 	Vedbedi, rangamati 	1	2000	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-08 04:06:08.758	2026-07-08 07:52:51.501	\N	\N	0	\N	f	ONLINE
050fafa0-25ac-459e-b4db-14ec29d8c673	\N	\N	6547980	Ariyan	01892018995	Chaprashirhut 			noakhali 	Noakhali companyganj chaprashirhut 	1	3500	4520	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-08 06:38:52.823	2026-07-08 07:52:57.418	\N	\N	0	\N	f	ONLINE
e2a07080-1d63-40f0-a7fa-62583f778d80	\N	\N	8865570	Ariyan	01874723626	Chaprashirhut 			noakhali 	Noakhali companyganj chaprashirhut 	1	3500	4520	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-08 06:42:37.57	2026-07-08 07:53:02.416	\N	\N	0	\N	f	ONLINE
8cc36663-3597-49b3-8d48-f62a741f4e33	\N	\N	8114270	Moshiur Rahman Mahi 	01628482597	intermex road,joydebpur,Gazipur		mahimosiur810@gmail.com	Gazipur 	Joydebpur 	1	3500	4520	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-08 08:39:24.403	2026-07-08 08:42:02.343	\N	\N	0	\N	f	ONLINE
f153d09a-b271-43d1-9566-e1cf19d7c64b	\N	\N	8020660	Joni miazi	01876-942000	Sukchail, chouddagram, comilla		joniiub@gmail.com	Comilla	Sukchail, chouddagram, comilla	1	4000	5320	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-08 19:27:34.227	2026-07-09 08:37:20.97	\N	\N	0	\N	f	ONLINE
8c198eac-5da8-4aeb-9866-842f5b85776e	\N	\N	1039831	Joni miazi	01876-942000	Sukchail, chouddagram, comilla		joniiub@gmail.com	Comilla	Sukchail, chouddagram, comilla	1	3500	5320	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-08 19:16:18.114	2026-07-09 08:37:25.541	\N	\N	0	\N	f	ONLINE
d557091c-8250-40a5-bd09-24336b68223b	\N	\N	5105971	TaNviR Alam	01736951837	Jogonthpur Ranigonj to holikuna bazar 		tanviralom95183@gmail.com	Sunamganj 	Khagaura	1	3500	4520	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-08 17:27:05.368	2026-07-09 08:40:37.67	\N	\N	0	\N	f	ONLINE
7cbcd461-76c7-4c5d-9a59-c7e54c99b15c	\N	\N	5853421	Md Rimon miah 	01964843379	Mostul 300feet police box,mostul, khilkhet,  Dhaka -1229			Dhaka 	Dhaka 	2	3200	4260	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-08 16:54:38.868	2026-07-09 08:42:40.762	\N	\N	0	\N	f	ONLINE
a72cde53-42fb-4bd7-b9e3-e746d3b32ba6	\N	\N	2308830	Mohammad Rashedul Hoque	01817784046	Aerial Legend, 4th floor, CDA Avenue, GEC Circle, Chattogram 		rashedul.barc@gmail.com	Chattogram 	Chattogram 	1	3500	4520	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-08 16:32:11.401	2026-07-09 08:43:28.111	\N	\N	0	\N	f	ONLINE
2f1b38cb-b859-4f2b-9ba0-857cf6f07869	\N	\N	8531450	Rayhan 	01605075614	Naogan mastarpara			Naoga	Naoga 	1	2000	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-08 15:18:25.545	2026-07-09 08:44:21.604	\N	\N	0	\N	f	ONLINE
4a74308a-0f9d-4806-8618-8c91f75bfb89	\N	\N	6047761	Imam Bukhary	01613558438	Jethagram, Nasirnagar, Brahmanbaria 		imambukhary11@gmail.com	Brahmanbaria	Jethagram, Nasirnagar, Brahmanbaria 	1	4000	5320	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-14 00:41:50.593	2026-07-14 10:34:07.791	\N	\N	0	\N	f	ONLINE
fbc0a61b-7d0f-421f-9d83-ae06cd9cd721	\N	\N	1114800	Emran H Joni	01941403799	??????????????? ????????? 		emranjoni028@gmail.com	??????????????????????????? 	???????????????????????? ?????????????????? ??????????????????????????? 	1	1250	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-08 22:19:35.692	2026-07-09 08:35:48.107	\N	\N	0	\N	f	ONLINE
89d33c45-5af6-4d95-bfdf-27db7d1ba045	\N	\N	8781730	Abdul ahad	+8801716853970	Office 		usjisan@gmail.com	Sylhet 	Sylhet Fenchugonj Maijgow AVC air 	1	2700	2820	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-10 10:54:46.207	2026-07-10 17:38:29.855	\N	\N	0	\N	f	ONLINE
663a1e0f-83f1-498f-b80c-e6d773df969d	\N	\N	2348380	Md Nirob	01889097084	ambagicha,aganagor,south Keraniganj ,dhaka 1310		nirobafnan786@gmail.com	Dhka		1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-10 09:04:37.164	2026-07-10 17:38:35.092	\N	\N	0	\N	f	ONLINE
51747e56-5c5a-4fa7-91a3-9bdea3ab7dae	\N	\N	9551921	Alishba Zaina	01777525027	Block -f No-115, Banani Chairmanbari Dhaka		alishbaasif2024@gmail.com	Dhaka	Banani chairmanbari	1	1250	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-10 05:39:57.625	2026-07-10 17:38:39.985	\N	\N	0	\N	f	ONLINE
f26894ad-911e-4ba9-86a5-27a10ef1f5e7	\N	\N	7699821	???????????? 	01330043134	???????????????- ?????????????????????????????? ????????? ????????????,,,???????????? - ??????????????????,,,????????????- ??????????????????????????????????????????		mirsohan805@gmail.com	??????????????????????????????????????????	???????????????- ?????????????????????????????? ????????? ????????????,,,???????????? - ??????????????????,,,????????????- ??????????????????????????????????????????	1	3500	5320	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-10 04:14:33.791	2026-07-10 17:38:43.923	\N	\N	0	\N	f	ONLINE
69916eb5-72bc-4564-83e9-9891c5bc5458	\N	\N	5164410	ABDULLAH NAYEEM	+8801921724445	Deboi bazar rupgonj Narayananj 			Narayanganj 	Deboi bazar rupgonj Narayananj 	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-11 09:03:05.714	2026-07-11 11:10:54.409	\N	\N	0	\N	f	ONLINE
7a19c20a-1253-4e18-8c7b-7913a44735d3	\N	\N	5951440	Nurulamin 	+880 1726-984683	??????????????? ?????????????????? ???????????????, ????????????????????????		rk7717142@gmail.com	??????????????????????????? 	??????????????????????????? 	1	3500	5320	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-10 23:54:47.538	2026-07-11 11:12:48.798	\N	\N	0	\N	f	ONLINE
dd6bc61c-430f-4428-a503-b09f35891805	\N	\N	6262331	Abrar Mahdi Pantha	01760449587	Dhanmondi Sankar rayer bazar community Center 		mahdipantha3@gmail.com	Dhaka		1	1700	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-10 20:51:25.477	2026-07-11 11:13:56.792	\N	\N	0	\N	f	ONLINE
3fcbbab9-1570-4d70-b6ca-030d4f0981c9	\N	\N	0704850	SAJID ISLAM	01970689673	Tongi / charagali/sing Bari mosjid 			Gazipur 	Tongi / charagali/sing Bari mosjid 	1	3500	5320	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-10 18:45:38.197	2026-07-11 12:55:38.844	\N	\N	0	\N	f	ONLINE
df45c2ca-eb30-4694-ae22-57e7cbc7b33e	\N	\N	9105640	Miraj	01711708327	Shiromoni,khan jahan ali khulna			Khulna	Shiromoni,khan jahan ali khulna	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-10 20:06:36.399	2026-07-11 17:43:01.297	\N	\N	0	\N	f	ONLINE
b24664e7-6dfd-4683-87a7-fb222250f249	\N	\N	6967930	protush das	01873091999	7b,Manjar Heights, kholifapotty,		dasprotush470@gmail.com	Chittagong 	20no dewan bazar,Kotwali, Chittagong 	1	1250	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-11 14:40:16.61	2026-07-12 11:15:25.305	\N	\N	0	\N	f	ONLINE
0cb9bbd7-69cc-4f57-a709-d1fddc5ee361	\N	\N	1286650	Samuel chakma	01615111796	Konglak Pahar, Sajek Valley, Baghaichari, Rangamati 		samuelchakma763@gmail.com	Rangamati 	Sajek Valley 	1	4000	5320	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-11 14:46:33.84	2026-07-12 11:16:45.164	\N	\N	0	\N	f	ONLINE
977be6f6-11c3-44cf-afd0-945bee0dd9bd	\N	\N	9734521	parvez milon	01307494909	Uttara sec10 road 8/a house1 		parvezmilon1994@gmail.com	Dhaka 	Dhaka Uttara 	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-11 19:44:00.072	2026-07-12 11:17:33.63	\N	\N	0	\N	f	ONLINE
907baa5c-0ce2-4633-ad90-1ccf91236a99	\N	\N	7068271	Bijoy	01312949009	Daudkandi bazar			,Comilla 	Daudkandi bajar	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-12 04:49:24.459	2026-07-12 11:18:46.891	\N	\N	0	\N	f	ONLINE
2d4fb9a8-eb79-457f-a2e2-5ec3ccdb70e4	\N	\N	4403000	Shohag	01962340475	Shariatpur, Nariya, Panditsar 			Shariatpur 	Shariatpur 	1	1250	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-12 06:58:32.775	2026-07-12 11:26:06.463	\N	\N	0	\N	f	ONLINE
c2350f2f-178b-43c4-99c2-4a6c703fcd5b	\N	\N	2530970	Ujma Rubab 	01683491855	Katalganj, Road 1, House name : Salim Bagh, 3rd floor, flat 5A.		ujma15rubab@gmail.com	Chittagong 	Katalganj, Panchlaish. 	1	1080	2190	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-12 19:10:42.71	2026-07-12 20:38:55.988	\N	\N	0	\N	f	ONLINE
db5ccb23-e9a8-4025-817d-22ce1c811225	\N	\N	5307751	Faizan Rahman 	01798216391	Dncc-72, Shahjadpur 30acre near solaiman kindergarten school Gulshan Dhaka1212 		mizanur.rahman20@northsouth.edu	Dhaka 	Gulshan 	1	3500	5320	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-12 17:17:19.532	2026-07-12 20:43:53.495	\N	\N	0	\N	f	ONLINE
884ac177-5eef-4d9a-9990-e87fffdd5841	\N	\N	4604391	Suriya	01763681629	House 1184. Avenue 11. Road 50. Mirpur dohs 		suriyamansur2@gmail.com	Dhaka	Mirpur 	1	2000	2600	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-13 02:42:28.85	2026-07-13 10:23:56.795	\N	\N	0	\N	f	ONLINE
fb0f9780-d661-4470-a766-ef50ebf6a83f	\N	\N	0206790	Wasif Hossain	01778071980 	Sector 7 Road 8 house 1		saadmanhossain083@gmail.com	Dhaka 	Uttara 	2	2000	3720	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-13 04:14:07.499	2026-07-13 10:26:01.491	\N	\N	0	\N	f	ONLINE
e8409d60-6018-4fc6-a336-9790d5684e3d	\N	\N	5419040	Arabi Ahmed parvez	01690000561	Athobarpor.chandina.comilla		pk2247924@gmail.com	Comilla	Atobarpor	1	2000	1270	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-13 07:29:01.546	2026-07-13 10:30:22.597	\N	\N	0	\N	f	ONLINE
3c12272d-ebd6-4d8f-86f9-6bb7b28ea25f	\N	\N	7311971	Tamim	1407564386	1/4 ring road		nagayouknow@gmail.com	Dhaka	Rupnagar,mirpur 2	1	4000	5280	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-13 10:00:29.658	2026-07-13 12:04:06.154	\N	\N	0	\N	f	ONLINE
a8e860f8-70b8-4a98-848f-cc8a0985055a	\N	\N	5634361	Fuad Hossain 	01646260230	Uttara,sector:15,Block:F,Road:3A,House:22		fuadhossain319@gmail.com	Dhaka	Uttara,sector:15,Block:F,Road:3A,House:22	1	1000	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-13 11:03:57.819	2026-07-13 12:04:18.062	\N	\N	0	\N	f	ONLINE
ee1da967-177d-4de0-84ac-2c2d39ea843f	\N	\N	7591360	Kazi Suzal	01934091566	Missionpara,Chashara,Narayanganj		victoryalpha025@gmail.com	Narayanganj	Missionpara,Chashara,Narayanganj-1400	2	2000	3720	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-13 13:55:16.265	2026-07-14 10:23:26.469	\N	\N	0	\N	f	ONLINE
887f94a8-7baa-46b6-b95a-d0dcb6b49b98	\N	\N	0036390	Marjan Hussain  Rahib	01316886601	Burhanpur/Nabiganj 		marjanrahib15@gmail.com	Habiganj 	Nabiganj 	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-13 13:58:11.635	2026-07-14 10:24:26.506	\N	\N	0	\N	f	ONLINE
648ed258-6274-4e87-8032-de490126a755	\N	\N	9308440	Sujon chakma	L01533787340	Tnt raybahadur sarok		sujonchakma4@gmail.com	Rangamati 	Rangamati Sadar 	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-13 17:16:33.6	2026-07-14 10:27:20.784	\N	\N	0	\N	f	ONLINE
03d57c7c-d43f-4438-8690-0f6a55eec39a	\N	\N	7024700	Shanoy Rahman Pele	01788-070152 	Daffodil International University. Birulia, Savar			Dhaka	Daffodil International University.  Birulia,Savar 	1	1000	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-13 21:39:19.297	2026-07-14 10:29:04.218	\N	\N	0	\N	f	ONLINE
eaeffc3f-d837-49f2-9d99-74de341d2667	\N	\N	5280060	Tanvir Bepari	+8801932834459	Bagasura, dorga gait, olipur,		tanvirahmed.mbb@gmail.com	Hobigonj	Bagasura, dorga gait, olipur,	1	1800	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-13 13:01:12.653	2026-07-14 10:22:26.041	\N	\N	0	\N	f	ONLINE
d0dc2a37-180c-4772-8ced-80f773cae4bd	\N	\N	9077150	ahoshan kabir	01797681968	Mulatol guratipara 		ahoshankabirr@gmail.com	Rangpur		1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-13 21:43:34.858	2026-07-14 10:29:58.134	\N	\N	0	\N	f	ONLINE
43fc6e05-5b7a-49e5-aca8-2f88566ff67a	\N	\N	9920550	Rubayed	01306041247	peyaratola			Kushtia	peyaratola,kushtia sadar	1	4000	4520	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-13 22:34:17.381	2026-07-14 10:31:12.054	\N	\N	0	\N	f	ONLINE
038fb9f2-4ef1-4d6a-904e-c855b01b5eca	\N	\N	6536451	Mirja Galib 	01798216391	Dncc-72, Shahjadpur 30acre near solaiman kindergarten school Gulshan Dhaka1212 		mizanur.rahman20@northsouth.edu	Dhaka 	Gulshan 	1	4000	5320	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-13 23:01:50.632	2026-07-14 10:31:52.508	\N	\N	0	\N	f	ONLINE
9d02b632-a6a8-4f20-8805-62edfce82eaf	\N	\N	9304990	Sujon 	+8801317638123	Foy's lake,btv er samne 		sadiarehman8779@gmail.com	Chattogram	Foy's lake,btv er samne 	1	1500	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-14 08:00:01.29	2026-07-14 10:35:34.624	\N	\N	0	\N	f	ONLINE
c82e58f5-418b-4636-b71a-53bdc0bea7a0	\N	\N	8064630	Zareen	01971566007	Zareen shaiyan usmany 01971566007 FLAT 8 AB Paradise garden 143 ,144,Sher-E-Bangla Road.West Dhanmondi, Rayer bazar Dhaka		zareensu123@gmail.com	Dhaka	Zareen shaiyan usmany 01971566007 FLAT 8 AB Paradise garden 143 ,144,Sher-E-Bangla Road.West Dhanmondi, Rayer bazar Dhaka	1	3500	4480	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-14 10:29:31.06	2026-07-14 10:51:10.987	\N	\N	0	\N	f	ONLINE
0330de22-1e76-411f-bb13-1f87bcbe6b5b	\N	\N	9687010	Saima Rahman	01711082888	202/4 West Kafrul, Rokeya Soroni, Dhaka-1207		saimarahman1980@gmail.com	Dhaka	West Kafrul	1	1500	2150	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-14 14:24:44.791	2026-07-14 17:51:53.251	\N	\N	0	\N	f	ONLINE
ff7d9acf-2929-4c07-80c9-eac54d81b7ff	\N	\N	8061210	Faiza 	01330604592	Taknikal mor easy health 		faizaalamomia2526@icloud.com	Dinajpur 	Nimnagar balubari dinajpur sadar 	3	8500	10920	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-07-16 11:20:54.3	2026-07-16 11:50:34.281	\N	\N	0	\N	f	ONLINE
2190b33b-0c42-41db-81c2-8afb53a2e120	\N	\N	2975071	Ankit Chowdhury	+917439145152	6 canal south road tangra kolkata 700015		ankitchowdhury2711@gmail.com	Kolkata	6 canal south road tangra kolkata 700015	1	2000	2640	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-07-14 19:01:15.444	2026-07-14 20:13:10.407	\N	\N	0	\N	f	ONLINE
d3271183-82c8-40c0-b927-ba452aee941e	\N	\N	2632771	Sachet 	9321453983	A 602 sonal classic bldg bhardawadi rd andheri west		sachxtgada@gmail.com	Mumbai 	Mumbai Maharashtra 	1	1250	2370	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-07-14 19:45:50.148	2026-07-14 20:13:15.584	\N	\N	0	\N	f	ONLINE
97f00d19-9720-4f47-80d5-55dc20c9cf41	\N	\N	0878750	Tahsin Jahin	01875784087	Kasem residential Area,Harun Manjil		akontahsin7@gmail.com	Noakhali 	Maijdee,White Hall	1	1250	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-15 06:50:17.988	2026-07-15 11:32:09.143	\N	\N	0	\N	f	ONLINE
69ceadc1-9a59-4d22-9756-c2a1319c36b7	\N	\N	7942130	Ziaur Rahman	01727532704	House 46 road 20 sector 11		zr240102007@gmail.com	Dhaka	Uttara	1	1700	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-15 06:10:37.909	2026-07-15 11:32:29.941	\N	\N	0	\N	f	ONLINE
0e10560f-3fb6-48ec-bf33-57a014a933f3	\N	\N	3951240	Rashed	01683320107	Shilpakala Academy Segunbagicha paltan Dhaka 			Dhaka 	Eletician, Shilpakala Academy Segunbagicha Dhaka 	1	1000	1920	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-07-16 13:10:35.838	2026-07-16 13:20:23.665	\N	\N	0	\N	f	ONLINE
1224b77d-41ea-4773-b349-cf2bd0ddb62b	\N	\N	6124991	Yasir Zafar	01973650831	Beside Bangladesh Specialized Hospital, Building name: Anwar Landmark Sensation		yasirzafar066@gmail.com	Dhaka	17/18 Hossain Housing society,Shamoli,Dhaka	1	1200	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-15 12:31:42.152	2026-07-16 17:32:34.177	\N	\N	0	\N	f	ONLINE
f50ed313-09fb-46d1-95d6-0d0353daf93c	\N	\N	8346251	Khalid	01779600019	Kushtia kumarkhali hall bazar 		mdkhalidhasan7010@gmail.com	Kushtia 	Kushtia kumarkhali hall bazar 	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-15 22:35:17.72	2026-07-16 17:34:14.441	\N	\N	0	\N	f	ONLINE
3c491398-7fb4-415b-85d1-ae70e23eac89	\N	\N	4693670	Rocky 	01968151642	19/3 west panthapath 		rafin.hussain09@gmail.com	Dhaka	Dhaka	2	2000	3680	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-15 23:02:29.831	2026-07-16 17:36:13.75	\N	\N	0	\N	f	ONLINE
368a364c-e4de-46dc-9b52-ca6e862875ef	\N	\N	7035311	Talha	01883220415	Khilkhet Dhaka Madhabdi child care school 		wahidmunna4@gmail.com	Dhaka	Medhadi child care school khilkhet Dhaka 	1	1000	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-16 08:32:43.936	2026-07-16 17:38:03.681	\N	\N	0	\N	f	ONLINE
2baa54b0-38a6-49f4-a318-d9d5eb01889d	\N	\N	8140850	Talha	01883220415	Khilkhet Dhaka Madhabdi child care school 		wahidmunna4@gmail.com	Dhaka 	Khilkhet Dhaka Madhabdi child care school 	2	2700	4170	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-16 08:34:13.407	2026-07-16 17:38:12.248	\N	\N	0	\N	f	ONLINE
557eacb0-be08-4036-b1df-c3819e24b021	\N	\N	8446590	Siam	01641954141	Armanitola ssc road dhaka 1100		siamsunny4911@gmail.com	Dhaka	Armanitola ssc road dhaka 1100	1	1300	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-16 09:09:07.432	2026-07-16 17:40:28.333	\N	\N	0	\N	f	ONLINE
18f330bb-b341-411c-95f8-916777846caf	\N	\N	1332781	Mahmud Akib	01755006778	South Banasree 66/143		ama811244@gmail.com	Dhaka	Dhaka Banasree 	1	1250	2600	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-16 14:14:48.45	2026-07-16 17:41:43.899	\N	\N	0	\N	f	ONLINE
537d62d0-76ac-4880-9fa9-db25c1697dab	\N	\N	8983321	Rifat	01575767340	Darus salam tower		rifat77777999999@gmail.com	Dhaka	Daus salam tower mirrpur1	1	1700	2600	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-17 08:45:49.914	2026-07-17 10:51:28.354	\N	\N	0	\N	f	ONLINE
aca63449-0216-4f4d-b0fe-5db795eb9b5b	\N	\N	4757550	Niloy Khan	01877028878	???????????? : ?????????????????????????????? / ????????????: ??????????????????????????? / ??????????????? : ???????????????????????????????????????		niloykhan03042007@gmail.com	Dhaka 	???????????? : ?????????????????????????????? / ????????????: ??????????????????????????? / ??????????????? : ???????????????????????????????????????	1	2500	3720	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-17 08:06:20.585	2026-07-17 10:53:11.854	\N	\N	0	\N	f	ONLINE
3be4d3b3-d54f-40da-8606-0f1dbadfdb76	\N	\N	8969721	Hafiz	01724229793	Pallabi 			Dhaka 	2/12 Pallabi Mirpur Dhaka 1221	1	2000	1270	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-17 06:34:44.074	2026-07-17 10:54:07.954	\N	\N	0	\N	f	ONLINE
88d3ac86-984c-4b49-ab4e-e7204975feeb	\N	\N	6168171	Sumaia	01876703274	Daudkandi bajar,Comilla			Comilla	Daudkandi 	2	2000	3360	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-17 02:51:07.485	2026-07-17 10:56:03.784	\N	\N	0	\N	f	ONLINE
727e3a9b-c27d-471d-aac2-2ae4a89a39d4	\N	\N	8892450	Forhad Islam	01771955234	77 Malitola Road, Bangshal, Dhaka -1100		islamhridoy008@gmail.com	Dhaka	Dhaka 	1	1700	2330	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2026-07-16 20:16:58.772	2026-07-17 10:57:25.107	\N	\N	0	\N	f	ONLINE
85bff999-c834-4192-886e-3589ab7f77b1	\N	\N	1426350	Shakib	+8801813287386	Dakshinkhan 		rahmanshakib199@gmail.com	Dhaka	Dhaka	1	1000	1880	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2026-07-17 14:23:20.932	2026-07-17 18:46:14.323	\N	\N	0	\N	f	ONLINE
4d4b1d67-b0bc-46d0-941d-b5dbda9d3281	\N	\N	6488211	Jaki Abrar	01781075683	Gas field,Chiknagool 		krahman.sgfl@gmail.com	Sylhet	Jaintapur	1	1250	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-18 10:15:06.737	2026-07-18 10:54:05.928	\N	\N	0	\N	f	ONLINE
0bda9dbf-a671-4193-ae0f-32a0fe89d01f	\N	\N	7578051	Inan Raim	01758617823	Shalbagan petrol pump er pasher rasta		inanraim8@gmail.com	Rajshahi	Sopura,Rajshahi	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-18 09:43:25.376	2026-07-18 10:57:12.706	\N	\N	0	\N	f	ONLINE
baef8112-7d6f-472c-a68a-8450dcd783ff	\N	\N	3309980	Tahsin Jahin	01875784087	Kasem Residential area, Harun Manjil,2nd Floor		akontahsin7@gmail.com	Noakhali 	Maijdee, White Hall	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-18 07:07:11.327	2026-07-18 10:58:23.179	\N	\N	0	\N	f	ONLINE
f518b507-0d67-4223-81bc-12b6749f5fa1	\N	\N	3051220	Md Ziaul	01739137238	Bhawanipur.atrai.naogaon		nipu.rn36@gmail.con	Naogaon	Bhawanipur 	1	3500	4520	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-18 06:15:36.467	2026-07-18 10:59:41.635	\N	\N	0	\N	f	ONLINE
bfa54407-d9e6-4a06-bba3-452d4131fbba	\N	\N	1218311	Md Ziaul	01739137238	Bhawanipur.atrai.naogaon		nipu.rn36@gmail.con	Naogaon	Bhawanipur 	1	3500	4520	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-18 05:06:20.084	2026-07-18 10:59:47.692	\N	\N	0	\N	f	ONLINE
a8785b83-a660-4e0c-be32-12922738c213	\N	\N	2605970	Fardi Fahi	01706296466	Kuet main gate		fardinbijoyfahim@gail.com	Khulna	Fulbarigate,Kuet, Khulna	2	2950	4620	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-17 22:12:08.219	2026-07-18 11:01:02.243	\N	\N	0	\N	f	ONLINE
6e194936-d9ee-44c4-8267-16c930072e63	\N	\N	4604820	Abid Ahmed 	01732734758	Sylhet. Golapgonj. Mirgonj bazar 		saidahmedabid6@gmail.com	Sylhet 	Sylhet. Golapgonj. Mirgonj bazar 	1	1250	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-17 21:48:17.45	2026-07-18 11:04:24.202	\N	\N	0	\N	f	ONLINE
c6d97757-176d-41fb-89b2-017fbc626c5f	\N	\N	2887351	Khondoker Zarin	01746211449	House- 1/8, Block-C, Lalmatia 		zarintasneem25@gmail.com	Dhaka	Dhaka-1207 	1	1700	2600	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-17 20:15:42.526	2026-07-18 11:07:27.739	\N	\N	0	\N	f	ONLINE
6ad05655-9c17-491f-aeb1-15e76f1ebb86	\N	\N	2372781	Khondoker Zarin	01746211449	House- 1/8, Block-C 		zarintasneem25@gmail.com	Dhaka	Lalmatia, Dhaka- 1207 	1	1700	2600	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-17 20:14:39.781	2026-07-18 11:10:03.289	\N	\N	0	\N	f	ONLINE
7f852344-1c77-4938-8d20-1e159a4e5648	\N	\N	0787501	Asif	01752045202	40/D South Kamalapur Motijheel Dhaka-1217		salmanislamsakib@gmail.com	Dhaka	Motijheel	1	1000	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-17 20:12:17.116	2026-07-18 11:13:45.553	\N	\N	0	\N	f	ONLINE
703d45e3-89d6-439b-a20b-e7de12887056	\N	\N	8657591	??????????????? ???????????????	01877996232	Kholahatti Cantonment, parbotipur,Dinajpur		tarekrahaman4519569@gmail.com	Dinajpur 	Kholahatti Cantonment, parbotipur	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-17 19:53:12.685	2026-07-18 11:15:49.934	\N	\N	0	\N	f	ONLINE
8577b624-d23c-458c-b82a-181916613130	\N	\N	8560820	parvex Hossain 	01947889425	Eccta Dhaka Ltd. Natun Nagor, Sreepur,Ashulia, Dhaka 1339		parvezh7399@gmail.com	Dhaka	Bangladesh	1	3500	4480	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-17 16:00:04.37	2026-07-18 11:17:03.184	\N	\N	0	\N	f	ONLINE
8ae67f45-20a4-4f08-a7f6-5daf796848e6	\N	\N	0607260	Shahadat Hossain Sadat	01757081306	Japan City Garden,tokyo Square Shopping Mall(shop No: 215) 1st Floor		sadatvai75@gmail.com	Dhaka	Mohammadpur 	1	1000	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-17 17:08:40.909	2026-07-18 11:17:14.226	\N	\N	0	\N	f	ONLINE
66ab7d9f-6048-4737-8810-187d01c61deb	\N	\N	8138841	Siam bin hossain	01608616229	Banasree road 3,block -B,house-7		mehrabbinhossain97@gmail.com	Dhala	Banasree road 3,block -B,house-7	1	1700	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-18 11:39:48.73	2026-07-18 12:04:28.604	\N	\N	0	\N	f	ONLINE
29c1de80-0ebe-478c-a437-16d23968694d	\N	\N	3392161	Muhammad 	01615519854	2 no pul tegoria,  Habiganj sadar 			Habiganj 		1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-19 20:20:34.38	2026-07-21 00:09:20.901	\N	\N	0	\N	f	ONLINE
75944c6e-d54b-407c-9fd0-3c6abad2000f	\N	\N	3765491	Parnell	01742780448	Mirpur 11,avenue 1,Near bangla school		parnellmahmud@gmail.com	Dhaka	Mirpur	1	2000	2600	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-20 00:48:16.887	2026-07-21 00:09:31.782	\N	\N	0	\N	f	ONLINE
a66b5d4f-d4ef-47e0-8e0d-d75bee82146a	\N	\N	6317400	Tanim ayan	01623242733	Shapur		tanimaamir1@gmail.com	Brahmanbaria 	Kasba, Brahmanbaria 	1	1250	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-20 05:36:21.671	2026-07-21 00:09:42.298	\N	\N	0	\N	f	ONLINE
152ee17f-dec2-45a5-8e10-5ebd128e43c7	\N	\N	9610550	Saharia Sagor 	01403109784	Modern Clinic, Narail Sadar, Narail 		sahariasagor333@gmail.com	Narail 	 Narail Sadar, Narail 	1	1800	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-20 09:50:52.166	2026-07-21 00:09:54.012	\N	\N	0	\N	f	ONLINE
3a619a93-43d1-49c6-988f-d67d2ccc40a8	\N	\N	3473321	Faiza	01330604592	Nimnagar balubari Taknikal mor 		faizaalamomia2526@icloud.com	Dinajpur 	Nimnagar balubari dinajpur sadar 	2	6000	7320	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-20 09:56:37.501	2026-07-21 00:10:35.641	\N	\N	0	\N	f	ONLINE
4dbe0d5f-b336-4121-a68c-d8abaa6151bd	\N	\N	2433240	test	01748399860	test		test	dhaka	kakrail	1	1000	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-20 10:11:13.962	2026-07-21 09:18:18.468	\N	\N	0	\N	f	ONLINE
aa7c827d-1b5a-4ab0-946a-02e9fbe54e0b	\N	\N	1773861	Yasin arafv	01765321505	Dhaka, Dhaka - South, Ahsan Ullah Road, Shop 2/11, K.K Mansion Plaza Market 12/2, Ahsan Ullah Road, Islampur Rd, Dhaka 1100, Nearby: Islampur gol Talab Ahsan ullah Rd 01763772270		arafat.rafe2001@gmail.com	1100	Islampur	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-20 11:37:30.218	2026-07-21 09:19:48.106	\N	\N	0	\N	f	ONLINE
f8d1608f-3e78-4613-8550-cc35372705f3	\N	\N	9837611	Sayed islam	01731188498	Indira road boubajar patwori vila ??????-??? 		adnansayed230@gmail.com	Dhaka 	Panthapath square Hospital Dhanmondi 	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-20 17:37:39.352	2026-07-21 09:20:37.267	\N	\N	0	\N	f	ONLINE
684d7a6e-e509-46cb-830d-374337504ce1	\N	\N	2333160	rohan ahmmed	01941480637	Turag dhaka 1230 chandalvog r.s idal school 		rohanahmmed130@gmail.com	Dhaka	Chandalvog r.s idal school turag dhaka 1230 	1	1000	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-20 10:11:49.925	2026-07-21 09:22:38.705	\N	\N	0	\N	f	ONLINE
75e6fda6-8980-4e4a-91be-451ba52fb91c	\N	\N	9175591	Habib Mahmud 	01705533987	Cumilla homna gharmora 		hrhabibm573@gmaill.com	Cumilla 	Cumilla homna gharmora 	1	1600	1560	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-20 15:56:19.163	2026-07-21 09:30:51.237	\N	\N	0	\N	f	ONLINE
ad9b8a0d-ba0c-4a85-a641-781648e78faf	\N	\N	7305061	Tanika Tahjiba	01912160872	House-8, road-14, sector-12		tanikatahjiba@gmail.com	Dhaka	Uttara, Dhaka-1230	2	2500	4580	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-20 15:02:54.626	2026-07-21 09:32:04.777	\N	\N	0	\N	f	ONLINE
28ca2b0e-f639-4096-8d00-e0cbab151937	\N	\N	6665660	Nissan 	01739256353	Uposhohar b-330 Rajshahi sodor 		nissannabil@icloud.com	Rajshahi 		1	4000	5320	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-20 17:49:45.6	2026-07-21 09:32:58.578	\N	\N	0	\N	f	ONLINE
d5762f2c-a9d4-4285-8400-f66c0afcaf4a	\N	\N	0778711	Sifat hasan	01920671999	Fatullah jamuna gate ruposhi housing 		amonju888@gmail.com	Narayanganj 	Narayanganj 	1	1500	2820	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-18 17:03:47.884	2026-07-21 00:09:05.082	\N	\N	0	\N	f	ONLINE
b5b92fde-9080-4531-98be-a583466ab6b3	\N	\N	5375141	Moinul Karim Sojib	01890605050	????????? ??????????????????, ?????????????????? ??????????????? ?????????????????????, ?????????????????? ??????????????????/ ??????????????????, ????????????: ???????????????????????????		mksojib39@gmail.com	Cox's Bazar 	?????????????????? ??????????????????	1	1700	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-19 14:49:50.875	2026-07-21 00:09:12.93	\N	\N	0	\N	f	ONLINE
2170d524-922d-4282-9242-92ed6e1d7415	\N	\N	1645160	Sayed	01731188498	Indira road boubajar 			Dhaka 	square hospital Panthapath Dhanmondi 	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-21 05:20:09.815	2026-07-21 09:21:27.394	\N	\N	0	\N	f	ONLINE
69d48dc3-cbd5-4430-9fe9-70e9fc7915f1	\N	\N	4928141	Dr shovon	01724027867	Ad din hospital,Railroad, Jashore		dr.shovon.jes0108@gmail.com	Jashore 	Jashore sador	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-21 07:39:38.291	2026-07-21 09:28:10.518	\N	\N	0	\N	f	ONLINE
23356ff7-47f1-4614-951f-4e965684327c	\N	\N	7771260	Shihab Chowdhury 	01992001844	Chittagong gomal rosul market 2d floor 		ahnabchowdhury069@gmail.com	Chittagong 	Chittagong gomal rosul market 2d floor 	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-20 19:14:42.513	2026-07-21 09:34:33.422	\N	\N	0	\N	f	ONLINE
349e406c-db95-4321-ae9a-5a9bc4ef8139	\N	\N	3466200	Ahmed Shahriar	01795731321	House 17 Road 5 Dhanmondi		shahriarmails696@gmail.com	Dhaka	House 17 road 5 , dhanmondi 	1	1500	1330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-22 08:03:27.438	2026-07-22 11:07:42.31	\N	\N	0	\N	f	ONLINE
978e816e-41e2-4cd2-a830-975e0165b422	\N	\N	5762100	Mahedi Hasan	01742606060	jamtola mp goli		mehboob2320@gmail.com	narayanganj	jamtola mp goli	1	1250	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-22 07:33:04.546	2026-07-22 11:07:55.018	\N	\N	0	\N	f	ONLINE
01982964-eddb-4715-a153-bb6d144fae43	\N	\N	3522440	Farhan Fayzan	01302742898	Bongshal		farhanfayzan23@gmail.com	Dhaka	Bongshal mokimbazar jame mosjid	1	1000	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-21 21:46:54.495	2026-07-22 11:39:11.397	\N	\N	0	\N	f	ONLINE
a2e8db51-b97a-4ddf-a577-a69fe3a7bc10	\N	\N	6835201	Ahan Abrar 	+8801339410179	House-4, road-2, block-F , MIRPUR-1 		ahanabrar7@gmail.com	Dhaka	Mirpur 1	1	1700	2600	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-21 21:35:09.469	2026-07-22 11:39:21.627	\N	\N	0	\N	f	ONLINE
12bda93a-3e00-4050-be14-a0495bb66943	\N	\N	2606010	Maliha Islam Peya	01635780550	House:44/F/8, Lift-03, Creation Panthadhara, West Panthapath, Dhaka		peyaislammaliha@gmail.com	Dhaka	Panthapath	1	1250	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-21 21:28:52.226	2026-07-22 11:39:30.635	\N	\N	0	\N	f	ONLINE
8f4a55e8-696d-43b1-ac51-c0893d772508	\N	\N	3282310	Md alamgir 	01676428754	Halishahar k block , 8number gate , 3number road , 30number bari .		adibaadneen58@gmail.com	Chittagong 	Chittagong 	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-21 12:53:39.449	2026-07-22 11:39:48.572	\N	\N	0	\N	f	ONLINE
a14b9a01-2e52-4cdf-be42-57f2177e5f43	\N	\N	1249101	Mahedi Hasan	01742606060	jamtola mp goli		mehboob2320@gmail.com	narayanganj	jamtola mp goli	1	1250	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-21 19:45:33.641	2026-07-22 11:39:58.029	\N	\N	0	\N	f	ONLINE
086f5f54-e7f5-43e5-b365-dbc36d344fd0	\N	\N	7786341	??????????????? ?????????	01312952753	???????????????????????? ??????????????? ???????????? ??????????????????????????? ?????????????????? ???????????????????????? ???????????? ???????????????????????? ?????? ???????????? ?????? ????????????????????? ????????????		a96751639@gmail.com	??????????????? 	???????????????????????? 	4	3500	5320	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-21 16:54:39.654	2026-07-22 11:53:09.743	\N	\N	0	\N	f	ONLINE
06f6b3b6-8123-4822-a032-e07e23c74667	\N	\N	5587071	Iftekharul alam hasnat	01627290970	522,sk mujib road agrabad 		ifty.hasnat@gmail.com	Chittagong 	agrabad 	1	5000	5320	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-21 13:14:12.374	2026-07-22 11:53:14.29	\N	\N	0	\N	f	ONLINE
5c7effe6-b55b-48da-9346-f617512338c2	\N	\N	9918680	Sakib	01336764464	Seba city centar 		shakibhossain2369@gmail.com	Chandpur sadar	Chandpur sadar Seba city centar	1	1000	1920	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2026-07-22 16:17:29.731	2026-07-22 16:17:29.731	\N	\N	0	\N	f	ONLINE
c7abca30-d8f0-42a6-8967-321d4fb1dcad	\N	\N	5535591	Mahfuz Rahman 	01882160815	Godnail podma oil road Siddhirganj Narayanganj 			Narayanganj 		1	1500	2820	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-22 17:36:43.317	2026-07-22 18:06:32.113	\N	\N	0	\N	f	ONLINE
67cf7d16-7d8b-4b71-999d-d07bcd7e66a6	\N	\N	6534751	Mahedi Hasan	01742606060	jamtola mp goli		mehboob2320@gmail.com	narayanganj	jamtola mp goli	1	1250	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-22 13:58:05.855	2026-07-22 18:08:34.727	\N	\N	0	\N	f	ONLINE
8b7c3382-90b5-49d4-9b35-4c5b9b873ede	\N	\N	9852790	Mahedi Hasan	01742606060	jamtola mp goli		mehboob2320@gmail.com	narayanganj	jamtola mp goli	1	1250	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-22 16:49:54.579	2026-07-22 18:08:41.568	\N	\N	0	\N	f	ONLINE
7b8ed327-7b83-48c8-a594-3852567f1ae0	\N	\N	9455180	Rafsan Bin Faruk	01753809776	Prince road, Policeline, Cumilla		rafsanspark@gmail.com	Cumilla	Cumilla	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-23 00:20:47.09	2026-07-23 00:50:03.252	\N	\N	0	\N	f	ONLINE
46d97656-a4f3-4589-bbe7-715bce2e5500	\N	\N	7341401	Md Salman	01768266219	Mostofa Mansion		omesalman138@gmail.com	Feni	Mohipal,Fenii,3900	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-22 16:46:56.816	2026-07-23 00:51:04.195	\N	\N	0	\N	f	ONLINE
1d473b67-a1e7-4e8d-aacc-3caf191734d5	\N	\N	8414961	emon	01323231645	Chittagong Khulshi jalalabad tower  .		emonmohammadismail@gmail.com	Chittagong 	Khulshi	1	4000	5320	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-23 20:02:26.159	2026-07-24 11:40:16.772	\N	\N	0	\N	f	ONLINE
3acd9851-8ca1-4717-88f7-ea26e189262e	\N	\N	3625130	Rezaul Islam	1712958437	Rajbari baliakandi ramdiya		rezaul1997ram@gmail.com	Rajbari 		1	1700	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-23 22:40:14.602	2026-07-24 11:41:07.231	\N	\N	0	\N	f	ONLINE
fc5d0148-1495-4db3-9f98-078833d68f9f	\N	\N	0662751	Nayeemur	01841082864	House 5, Road 12, Rupnagar, Mirpur, Dhaka 1216		kousik.rtr@gmail.com	Dhaka	House 5, Road 12, Rupnagar, Mirpur, Dhaka 1216	1	1000	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-24 00:49:06.446	2026-07-24 11:42:54.554	\N	\N	0	\N	f	ONLINE
e4258402-b2da-4a9c-b382-6fc44e03aaf6	\N	\N	9984231	Fuad Hossain	01646260230	 Sector:15,block:f,road:3a,house22		fuadhossain319@gmail.com	Dhaka 	Uttara,sector:15,Block:F,Road:3A,House:22	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-24 10:47:50.741	2026-07-24 11:44:01.328	\N	\N	0	\N	f	ONLINE
0cc2631c-aeac-42be-ac43-f7daaf627561	\N	\N	2040400	sakil	01805721915	H:11/10,sattar molla road,mirpur 12,dhaka			dhaka	mirpur	1	1000	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-24 10:51:11.107	2026-07-24 11:44:57.728	\N	\N	0	\N	f	ONLINE
c3195e7c-de52-48b5-bb0d-20a85a0aa7fa	\N	\N	4905051	Jihad	01791970224	Bangalipur Nizpara			Nilphamari 	Saidpur	1	1500	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-24 10:55:40.68	2026-07-24 20:07:17.624	\N	\N	0	\N	f	ONLINE
f8e7728b-e30a-42b2-aeb6-00baa5673a9c	\N	\N	3393820	Rubaiyad Noor Shahirar	01609900407	Bibir Bagicha 2 No Gate, Near Water Pump, SS Gate, North Jatrabari, Dhaka		rubaiyadnoorshahriar@gmail.com	Dhaka	Jatrabari	1	4000	5280	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-24 00:20:19.981	2026-07-24 11:41:59.45	\N	\N	0	\N	f	ONLINE
cd91c9e9-5d74-44eb-bed5-33246232846e	\N	\N	9945051	Shishir Ahmed	01790488977	house 1, Block F, Road 6,Bansaree Dhaka 			Dhaka		1	1500	1000	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-24 12:45:41.082	2026-07-24 20:09:11.729	\N	\N	0	\N	f	ONLINE
06abdcbb-9aa8-41f5-89b8-4d37115f1634	\N	\N	0226600	Rafid Islam	01997833380	308/1 mirhazirbag,jatrabari,dhaka-1204			Dhaka	Dhaka	1	1000	1880	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-07-24 22:44:37.085	2026-07-24 22:44:37.085	\N	\N	0	\N	f	ONLINE
55516899-d455-4e07-99e1-e65263ec0f38	\N	\N	4960871	MD ROBIUL	01786579025	Road sonapur postal code-3802			Noakhali, shodor	Sonapur islami bank 	1	3500	4520	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-24 18:59:48.34	2026-07-25 22:53:17.946	\N	\N	0	\N	f	ONLINE
bd2eb9b9-8bbd-44ef-ba15-7bf0af6a5a1d	\N	\N	5823410	Rasel	+8801859197599	AFMI plaza shop no 301, Nasirabad , ctg		mdraseljr1@gmail.com	Chittagong 		1	1250	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-25 17:47:07.518	2026-07-26 09:13:37.009	\N	\N	0	\N	f	ONLINE
3b10dbea-3f71-46d9-b7eb-0c873bc88b3c	\N	\N	0851660	walid anowar	01815780002	Dewan bazar nirapad housing society block-2, Chittagong 		walid.anowar@gmail.com	Chattogram 	Bakolia	1	1700	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-25 10:14:06.612	2026-07-25 11:01:46.039	\N	\N	0	\N	f	ONLINE
0572d436-5af5-466e-af8c-c2b238a308d3	\N	\N	9154481	Protik Saha	01735107791	19/2 Kakrail Dhaka beside aurora hospital		sahaprotik10@gmail.com	Dhaka	19/2 Kakrail Dhaka beside aurora hospital	1	1700	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-25 09:15:44.971	2026-07-25 11:02:53.407	\N	\N	0	\N	f	ONLINE
fd63ac28-6c87-4494-8c8a-19d46c2ed000	\N	\N	1867061	Rahat	01798050265	Shahbazpur, Barlekha, moulvibazar		rahatnazatul6@gmail.com	Moulvibazar 	 Shahbazpur, Barlekha, moulvibazar	1	1250	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-25 03:30:58.033	2026-07-25 11:07:03.892	\N	\N	0	\N	f	ONLINE
f8f3af00-7d3a-4a31-b3c1-ab0d4ca05ee0	\N	\N	9650580	Nafin	01326892424	?????????????????????????????? ??????????????? ?????????????????? ???????????????????????? ???????????????????????? ?????????????????? 		nafin167@gmail.com	Dhaka	?????????????????????????????? ??????????????? ?????????????????? ???????????????????????? ???????????????????????? ?????????????????? 	1	1000	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-24 18:17:28.678	2026-07-25 11:10:26.421	\N	\N	0	\N	f	ONLINE
f0b45ffb-2a17-4bd7-9213-6cf5689a6568	\N	\N	6694951	Md romel	01318831015	Chandina , harong			Cumilla	Chandina 	1	3500	5320	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-07-25 08:55:01.648	2026-07-25 11:42:08.557	\N	\N	0	\N	f	ONLINE
3edc7ff9-ccb1-4d2e-bd58-f8585df5d99e	\N	\N	1315270	Arafa Chowdhury 	01609181194	Faridpur, alipur, green hospital mor 		arafaxoxo1849@gmail.com	Faridpur Sadat 	Faridpur, alipur, green hospital mor 	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-24 20:49:58.5	2026-07-25 11:58:09.387	\N	\N	0	\N	f	ONLINE
3e1006ff-567b-4fc8-8f0e-ee11b5daf1e9	\N	\N	7475190	Js	01761983386	kushtia mojumpur		joy9387@gmail.com	Kushtia 	Kushtia mill para kushtia sodor 	1	1500	2190	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-25 17:33:26.716	2026-07-26 09:58:59.383	\N	\N	0	\N	f	ONLINE
706a705a-027c-40e1-ae0b-69b9c6f15027	\N	\N	8125861	MD Rifat Hossain	01338697703	Mirpur-13/Block-B/Road-7/House-7		rifatboi123@gmail.com	Dhaka	Dhaka	1	1000	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-25 17:18:30.983	2026-07-26 10:02:22.362	\N	\N	0	\N	f	ONLINE
4948f7c1-f890-405f-b96e-ba58f56e713f	\N	\N	1637191	Ashraf Ali	01601462201	????????? ?????????????????? ??????????????? ??????????????????????????? ????????????		bache858@gmil.com	??????????????????????????????????????????  ?????????	????????? ?????????????????? ???????????? ??????????????? 	1	3500	4520	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-25 16:18:12.549	2026-07-26 10:34:02.828	\N	\N	0	\N	f	ONLINE
3d232920-c071-48b6-9b03-27d6debd75ea	\N	\N	0737190	Al Shad Rahman Raj	01764648174	Gulshan 2 road 50 house 3/B apartment 4		alshadrahmanraj@gmail.com	Dhaka	Dhaka Gulshan	1	1000	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-25 15:59:00.555	2026-07-27 00:05:23.066	\N	\N	0	\N	f	ONLINE
d2ca1d80-2aa1-4328-8f11-65665ec45191	\N	\N	9774101	Ahnaf hirash	+8801872176501	West ferozshah colony,lane:i,ak khan,ctg		ahnafhirash@gmail.com	Chattogram	Ak khan	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-02 00:20:54.593	2026-08-02 13:00:42.206	\N	\N	0	\N	f	ONLINE
765f9c5a-bd7c-400b-b824-a12637a15cad	\N	\N	6436181	Samii	01819789492	Hashadah			Chuadanga 	Jibannagar 	1	1700	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-29 10:57:55.806	2026-08-02 13:00:53.027	\N	\N	0	\N	f	ONLINE
ae7a03b7-6194-42a8-8b0e-0dd6853a3076	\N	\N	9255031	Md. Nasim Uddin	01882371858	Munsef Bazar,Patiya Upazila,Chittagong			Chittagong	Patiya Upazila	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-28 23:39:43.404	2026-08-02 13:00:59.248	\N	\N	0	\N	f	ONLINE
d6b94a9c-7155-4d9f-a35c-2245c5546326	\N	\N	1689041	Mahedi Hasan Talukder	01742606060	Jamtola Haider ali Road 		mirantalukder2011@gmail.com	Narayanganj 	Jamtola Haider ali Road 	1	1250	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-28 12:20:11.691	2026-08-02 13:01:08.88	\N	\N	0	\N	f	ONLINE
aed62341-f918-4265-a2ec-cfc9d33ddd2b	\N	\N	9480380	Sizan	01405300213	Mirpur 14.		ssijan644@gmail.com	Dhaka	Mirpur 14, Bhasantek, Talim Ghor Ibrahim construction office 	1	1000	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-26 15:49:47.031	2026-08-02 13:01:19.394	\N	\N	0	\N	f	ONLINE
c2353c5e-c9bd-4cd9-95d2-f927301c4bda	\N	\N	2370480	Osim	01954685775	Jibannagar 		darensami949@ gmail.com	Chuadanga 	Jibannagar 	1	1700	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-07-27 16:04:53.362	2026-08-02 13:01:27.057	\N	\N	0	\N	f	ONLINE
2731f727-e7d6-4c48-bba3-535606e03eba	\N	\N	8717360	Kazi Rukhsana Sehelin	01711086614	Ruby Razzle, House 10/a, Road 13 (extension), Baridhara, Dhaka 1212. Beside Hotel West Valley		ruki3004@yahoo.com	Dhaka	Baridhara	2	2750	4130	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-07-25 17:35:09.722	2026-08-02 13:01:38.213	\N	\N	0	\N	f	ONLINE
a10d282e-5d48-4643-aa2e-5a41ca6fa571	\N	\N	4456020	Md. Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	test	test	1	1300	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-02 16:34:18.873	2026-08-02 18:32:29.58	\N	\N	0	\N	f	ONLINE
c3e1c9d1-92ab-4dd6-b130-94c82997c2eb	\N	\N	6503271	Subha	01849611030	Apartment name-Junayed tower 		tasniaferoz@gmail.com	Dhaka 	Muktir mor, Thana road,Savar,Dhaka	1	1400	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-02 19:03:50.364	2026-08-03 09:00:44.253	\N	\N	0	\N	f	ONLINE
5415f540-8e78-4bd1-b054-e4524639b08d	\N	\N	3633861	Ishrak 	01643061415	House 74 75a, Road 3, Mohammadia Housing Limited,mohammadpur,dhaka			Dhaka	Mohammadpur 	1	1400	2150	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-08-03 05:23:28.71	2026-08-03 09:00:49.446	\N	\N	0	\N	f	ONLINE
2b0ace2d-6bc9-4293-8e0f-3accc749ece2	\N	\N	2998400	M Shanto	01751026014	Panchagarh jogdal bord office bzr		shahariarshanto6014@gmail.com	Panchagarh sodar, jogdal bord office bzr		1	1400	2370	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-08-04 08:49:34.165	2026-08-04 10:59:34.334	\N	\N	0	\N	f	ONLINE
1d8b3f02-5fa2-417e-bff9-592d1ff6c120	\N	\N	0119721	Tanim	01625698195	Beltola road		labibaltashfi@gmail.com	Pabna sadar	Dilalpur beltola road pabna sadar	1	1400	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-04 08:28:16.871	2026-08-04 11:05:52.025	\N	\N	0	\N	f	ONLINE
68eeb466-a58d-4469-a977-bfab8e060fa4	\N	\N	0552090	Rabbi Hossain 	01954528745	OFFICE NAME (UNI CONSULTANTS) 92, Ali Bhaban, 7th Floor, Kazi Nazrul Islam Avenue, Kawran Bazar, Dhaka, 1215		hossainrabbihossain92@gmail.com	Dhaka	Dhaka, Kawran Bazar 	1	1500	2150	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-08-04 07:55:46.752	2026-08-04 11:07:41.796	\N	\N	0	\N	f	ONLINE
d99f8a0f-2c58-4f06-8c46-147109331050	\N	\N	1196760	Rabbi Hossain	01954528745	OFFICE NAME (UNI CONSULTANTS) 92, Ali Bhaban, 7th Floor, Kazi Nazrul Islam Avenue, Kawran Bazar, Dhaka, 1215		hossainrabbihossain92@gmail.com	Dhaka	Dhaka, Kawran Bazar	1	1400	2600	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-08-04 05:44:31.098	2026-08-04 11:07:50.71	\N	\N	0	\N	f	ONLINE
502d5a98-eab0-4a46-94f0-be0b5efbde38	\N	\N	9214051	Sheikh Sami	01605952471	Baluchour Notun Bazar Sylhet Sadar		samirahman10022@gmail.com	Sylhet	Sylhet Sadar	1	1400	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-04 04:49:56.747	2026-08-04 11:08:43.885	\N	\N	0	\N	f	ONLINE
6e26844f-7218-480c-848d-0baa6ad2f63c	\N	\N	7984921	Mustafizur Rahman	01992805210	Sherpur , Sherpur Sadar , Nobinagor		mdmridul7326@gmail.co	Sherpur 	Mymensingh, Sherpur 	3	3000	5520	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-03 19:21:09.538	2026-08-04 11:10:11.577	\N	\N	0	\N	f	ONLINE
f84f0a97-47cf-4565-989b-3eb3ac68f627	\N	\N	5732790	Farzana Moumita	01627154521	House#38, Road#10, Sector#14, Uttara, Dhaka 		ledawij13@gmail.com	Dhaka	Uttara	2	8000	10480	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-08-03 18:43:35.817	2026-08-04 11:11:44.423	\N	\N	0	\N	f	ONLINE
76beae1d-73b3-4b1b-ba5e-a082627357e1	\N	\N	2946460	Rubayet rony 	01766260832	Posekha mur mawna Islamic madrasa 		rubayetrony2@gmail.com	Gazipur 	Mawna 	1	1400	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-03 17:49:36.58	2026-08-04 11:13:03.656	\N	\N	0	\N	f	ONLINE
1a1d9d99-d965-4242-969b-4f17ff721277	\N	\N	1436981	Mojahid	+8801333359894	????????? > Mojahid Mia  ????????????????????? > 01333-359894  ???????????? > ???????????????????????????   ???????????? > ????????????   ?????????????????? > Banshgari Islamia Dakhil Madrasah		mojahidmia12cv@gmail.com	????????? > Mojahid Mia  ????????????????????? > 01333-359894  ???????????? > ???????????????????????????   ???????????? > ????????????   ?????????????????? > Banshgari Islamia Dakhil Madrasah	????????? > Mojahid Mia  ????????????????????? > 01333-359894  ???????????? > ???????????????????????????   ???????????? > ????????????   ?????????????????? > Banshgari Islamia Dakhil Madrasah	1	1400	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-03 13:54:15.508	2026-08-04 11:16:03.916	\N	\N	0	\N	f	ONLINE
88589f91-7e45-4823-baec-341c15062c0e	\N	\N	7146130	Saber	01797272468	Road 4, block b 		spectorsaber10@gmail.com	Dhaka	Muhammadpur bosila city developers ltd, firoza bashar school 	1	1400	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-08-04 12:16:17.302	2026-08-04 12:29:38.461	\N	\N	0	\N	f	ONLINE
037de31b-430e-400d-aab7-0b9aafaffc30	\N	\N	0020221	Shakib Hossan	01689404906	2 number rail gate Narayangonj 		mdshakibhossan321@gmail.com	Dhaka Narayangonj 	2 number rail gate Narayangonj 	1	3500	5320	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-04 03:28:15.858	2026-08-04 13:57:51.801	\N	\N	0	\N	f	ONLINE
286dc959-9fb7-4fd0-97b1-030e2fcde221	\N	\N	1691060	Shakib Hossan	01689404906	2 number rail gate Narayangonj 		mdshakibhossan321@gmail.com	Dhaka Narayangonj 	Narayanganj 2 number rail gate	2	7000	10520	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-04 03:30:58.857	2026-08-04 13:57:56.077	\N	\N	0	\N	f	ONLINE
023286ca-768e-4518-bbe0-35a32ea210df	\N	\N	9127020	Shakib Hossan	01689404906	2 number rail gate Narayangonj 		mdshakibhossan321@gmail.com	Dhaka Narayangonj 	2 number rail gate Narayangonj 	3	10500	15720	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2026-08-05 03:19:37.957	2026-08-05 03:19:37.957	\N	\N	0	\N	f	ONLINE
c5cb61e3-2203-4671-b44e-12e8dff8ec13	\N	\N	4261181	Ashraful 	01805998088 	Manikpur School Road		01869621957asraful@gmail.com	Narayanganj 	Araihazar Manikpur road 	1	1400	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-05 07:38:57.342	2026-08-05 10:54:27.791	\N	\N	0	\N	f	ONLINE
33435b46-9904-4ca4-983d-7c9b3dd4c20b	\N	\N	7566411	Bappy Ahmed 	01639337699	Ghazipur boat Bazar Sonia goalie All har Madresa		miabappy570@gmail.com	ghazipur	Ghazipur	4	1400	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-04 18:07:24.812	2026-08-05 10:55:47.67	\N	\N	0	\N	f	ONLINE
257feb4b-af29-446d-9156-ddef8eb22c4b	\N	\N	0067650	Alif	+8801998191279	Shibpur ????????????????????????????????? ???????????? ?????????????????? ?????? ???????????????		kalif7314@gmail.com	Dhaka	Narshindi, shibpur	1	1400	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-08-04 17:04:43.203	2026-08-05 10:56:33.662	\N	\N	0	\N	f	ONLINE
c560d6cb-661d-407d-ba70-d824c03d7ea2	\N	\N	7493331	AHANAF Mormo	01982996882	Primary 		ahanafmormo9@gmail.com	Khulna	Khulna damoder  primary beside falguny buat depot	1	1700	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-04 15:03:37.833	2026-08-05 10:57:40.66	\N	\N	0	\N	f	ONLINE
6dea725f-612b-49e4-8489-dc64da550d14	\N	\N	4232771	Fardous Rohama	01829760753	Bhulta , gawsia rupganj			Narayanganj 	Narayanganj,rupganj,bhulta ,gawsia	2	7000	8920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-04 13:36:48.084	2026-08-05 17:46:31.776	\N	\N	0	\N	f	ONLINE
2b8134ea-eba9-4764-b7e6-a9a15704cfbf	\N	\N	3923381	AXY	000000000	AXZY			Dhaka	Dhaka	1	1400	2600	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2026-08-05 12:53:33.87	2026-08-05 17:48:07.219	\N	\N	0	\N	f	ONLINE
d221fba4-3a2e-42e2-8e3e-6d5c84cae89b	\N	\N	9711741	AXY	000000000	AXZY			Dhaka	Dhaka	1	1000	1880	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2026-08-05 13:19:35.836	2026-08-05 17:48:11.837	\N	\N	0	\N	f	ONLINE
c988b5d8-a5d2-48a9-9008-acf3b8b1aef7	\N	\N	1755940	Debopriyo podder rhythm	01761901140	Flat no:4A, Mobarak ali tower-2, shondhani general hospital, PTI mor,Bogura Sadar,Bogura		debopriyo podder	Bogura	Bogura sadar	2	2800	4620	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-05 16:44:24.801	2026-08-05 18:19:34.45	\N	\N	0	\N	f	ONLINE
2b50bbe1-bf23-4503-aa6b-e759f730e6b4	\N	\N	2313450	Antu Mondal	01307739434	Paikgacha Khulna		antum6615@gmail.com	Khulna 	Shibbati	1	1250	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-05 15:21:50.532	2026-08-05 18:20:21.441	\N	\N	0	\N	f	ONLINE
d265d679-f7ee-4be3-92cf-07c75fcfed9f	\N	\N	2991150	Riaz	1943268826	Khulna, Daulotpur Anjuman Road,Amtola Mor		mdriazsheikh70@gmail.com	Khulna	Daulotpur	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-05 15:05:59.4	2026-08-05 18:21:51.161	\N	\N	0	\N	f	ONLINE
088b5e06-2acf-4cd8-9a6f-6a296d9f1328	\N	\N	3040391	Arpo	1934946944	Palpara		shakimularpo4@gmail.com	Dhaka	Kishoreganj, Bajitpur 	1	1250	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-08-05 14:49:00.221	2026-08-05 18:24:49.614	\N	\N	0	\N	f	ONLINE
ca61abd9-2136-4392-883c-8064796e1efe	\N	\N	0372211	Arhab munna	01834892534	North badda,alir more,walton showroom		munnaarhab@gmail.com	Dhaka	Badda	1	1300	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-08-05 18:55:00.479	2026-08-06 08:39:58.431	\N	\N	0	\N	f	ONLINE
afea5077-36a6-4984-9022-aa4819138783	\N	\N	8449581	AXY	000000000	AXZY			Dhaka	Dhaka	3	2800	3770	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2026-08-05 19:57:29.529	2026-08-06 07:12:03.214	\N	\N	0	\N	f	ONLINE
53bba5fe-d0a7-45eb-b856-d6e58f7207ad	\N	\N	3452601	Tahaf Islam 	01334235211	Dhaka Gazipur moucak vannara beltola 		tahafislam68@gmail.com	Dhaka 	Gazipur 	1	2000	3720	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-06 03:56:04.649	2026-08-06 08:34:05.178	\N	\N	0	\N	f	ONLINE
d7d48a5e-88a9-47fb-9522-eebb8e2db790	\N	\N	4797810	Soumik Mugdho	01746551290	2nd road,supatola,beanibazar,sylhet		soumikmugdho@gmail.com	sylhet	supatola,beanibazar,Sylhet	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-05 18:45:56.341	2026-08-06 08:39:54.039	\N	\N	0	\N	f	ONLINE
cf6cf408-e7d6-4f67-b0ee-066e245c0195	\N	\N	9095890	Iqmamul Islam Rahi	01335260857	R,K Misson Road,Sreemangal Zila:Moulvibazar Thana:Sreemangal		rahi.islam558@gmail.com	Sylhet	Sreemangal	1	1400	2820	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-06 08:46:38.862	2026-08-06 08:51:26.152	\N	\N	0	\N	f	ONLINE
ea092ed4-8fc9-42a0-aa8d-cd23342bd02c	\N	\N	7844991	Atif Hasnat Sami	01345939972	Madhubpur upazila, Habiganj Zila		ragibahs@gmail.com	Habiganj 	Madhubpur Upazila 	1	1400	2190	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2026-08-07 13:55:03.749	2026-08-07 13:55:03.749	\N	\N	0	\N	f	ONLINE
8e48d1f7-ec26-4551-beea-50cd40633ba1	\N	\N	7614681	Zisan/Prapty	01637834538	House -800-801,Avenue -4,Road no- 11,Mirpur DOHS,Dhaka		skspondon111@gmail.com	Dhaka	House no-800,Road no-11,Avenue-04,Mirpur DOHS,Mirpur,Dhaka	1	1400	2150	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-07 23:37:45.925	2026-08-07 23:37:45.925	\N	\N	0	\N	f	ONLINE
69bc831a-e5f3-4dc5-928d-bb0eba4ee322	\N	\N	9721021	porimoni	01845678910	12/1, Rancon Building, 2A			dhaka	gulshan	2	2400	3770	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2026-08-05 20:16:58.8	2026-08-08 07:03:42.467	\N	\N	0	\N	f	ONLINE
41cc132c-4e25-4c54-8dde-110b3098e4d9	\N	\N	5861570	??????????????? ?????????????????? 	01854845844	??????????????????????????? ?????????????????????????????? 			??????????????????????????? 	?????????????????????????????? ????????? ?????????????????? 	1	3500	4520	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-06 16:29:09.506	2026-08-08 07:04:41.747	\N	\N	0	\N	f	ONLINE
64c9087c-2374-469d-82e6-0f476c41ed4c	\N	\N	9358550	Shanto	+8801830667881	Boiddargoan,, gajaria,, Munshiganj 		rasibzayaan3@gmail.com	Munshiganj 	Gajaria,, Munshiganj 	1	1400	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-06 17:39:57.664	2026-08-08 07:05:15.43	\N	\N	0	\N	f	ONLINE
71a2fcb6-1c4b-46b4-8ac6-5aa4ec6ab163	\N	\N	8337751	Saimon 	01819345213	Alam Bhabon, 2no mailer matha, Laila cng beporit goli, Bandar, Chittagong.		ppppppp.@gmail.com	Chittagong 	Bandar 	1	2000	3720	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-06 17:56:01.562	2026-08-08 07:05:27.221	\N	\N	0	\N	f	ONLINE
a09cd9ff-9cae-4aac-a476-aabe0e708083	\N	\N	1724601	Ramzan Ali	01711870275	Tangail Sadar, Akur Takur Para (Nobboi Bari)		jubairff2@gmail.com	Tangail Sadar	Tangail Sadar,  Akur Takur Para	1	1250	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-07 08:44:35.472	2026-08-08 07:05:37.286	\N	\N	0	\N	f	ONLINE
d06735e0-43b1-4f69-b0b9-0f099cbbccf0	\N	\N	6868531	Alok Deb Nath	01339564980	Tilaghor, Shaplabag-3, 40(A) Shahvilla		nalok.2024@gmail.con	Sylhet	Tilaghor, Sylhet Sadar	1	1400	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-07 12:31:03.308	2026-08-08 07:06:50.35	\N	\N	0	\N	f	ONLINE
a285e7ec-6c23-4aef-8aee-b539dfb7c2a8	\N	\N	3067780	Alok Deb Nath	01339564980	Tilaghor, Shaplabag-3, Shahvilla 40A		nalok.2024@gmail.con	Sylhet	Tilaghor, Sylhet Sadar	1	1400	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-08 09:12:59.066	2026-08-08 09:30:01.742	\N	\N	0	\N	f	ONLINE
e4ea9d9f-553f-4970-9988-f6a88e6f23bd	\N	\N	5016101	Alok Deb Nath	01339564980	Tilaghor, Shaplabag-3, 40A Shahvilla		nalok.2024@gmail.con	Sylhat	Tilaghor, Sylhet Sadar	1	1400	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-08 09:16:00.386	2026-08-08 09:30:09.728	\N	\N	0	\N	f	ONLINE
049f2969-cd4b-4f6f-b648-6578e82b12fc	\N	\N	4460590	shusanta deb	01938496142	Ramghatla near Awami league office , Kandirpar, cumilla 3500			Cumilla	Cumilla , Kandirpar 3500	1	1400	2820	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-08 08:59:23.612	2026-08-08 09:32:46.433	\N	\N	0	\N	f	ONLINE
2926ffb7-8dbd-4433-96ca-4fb01061cb98	\N	\N	3901351	wahidul islam	01841076181	cheragali surtorongo road ovijan 100/2		stsafayat51@gmail.com	gazipur 	tongi	1	1400	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-08 07:01:17.293	2026-08-08 09:33:32.378	\N	\N	0	\N	f	ONLINE
4471a393-3e40-47fa-9eaa-c32327a8de9d	\N	\N	1355661	Dolor ea hic qui a e	Est est eum eius ve	Consequatur Aliquam		hononomytu@mailinator.com	Corrupti tenetur pr	Aliqua Quod modi mo	1	1400	2640	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-08-09 18:12:23.95	2026-08-09 20:15:46.042	\N	\N	0	\N	f	ONLINE
18d9046b-1dca-4be8-92d4-7b8321637712	\N	\N	1194831	Excepteur laborum od	In et doloremque fac	Voluptas inventore d		sewim@mailinator.com	Voluptate est odio m	Architecto quos rem 	124	186000	279120	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-08-09 18:12:03.169	2026-08-09 20:15:56.135	\N	\N	0	\N	f	ONLINE
a1fc7e94-b584-420f-ab9a-a5d91c5ab07c	\N	\N	0622250	Delectus itaque vel	Aliquid et aut culpa	Sed sunt reiciendis 		rotovoquso@mailinator.com	Est nulla nihil qui	Dolores molestiae di	113	158200	284880	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-08-09 18:11:09.698	2026-08-09 20:16:06.933	\N	\N	0	\N	f	ONLINE
f00c0787-7797-41cd-888a-41c35f666c87	\N	\N	0473221	Ahad Alif	01628991440	Batakandi		mdalifmolla123@gmail.com	Cumilla	Uttur Aklya, Batakandi,  ???????????????. Cumilla.	1	1400	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-09 14:51:42.209	2026-08-10 07:26:16.868	\N	\N	0	\N	f	ONLINE
e7a4001d-588c-4cd2-946a-46eebd858ecf	\N	\N	9661891	Srabon khandoker	+8801306449305	South morail, monshibari		rssrabon444@gmail.com	Brahmanbaria	Brahmanbaria	1	1400	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-09 18:10:27.625	2026-08-10 07:29:06.663	\N	\N	0	\N	f	ONLINE
98fb14f8-d869-412c-90ed-da9da37a9b53	\N	\N	7261681	Mohammad shakil Ahammed shakil	01752766805	Bhairab bazar jame mosjid rode chanmiya market		msf611433@gmail.com	Kishoreganj 	Bhairab bazar 	1	3500	4520	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-09 18:23:49.91	2026-08-10 07:39:47.985	\N	\N	0	\N	f	ONLINE
7ae78a1b-bf49-4230-8503-228c2b360df9	\N	\N	0970730	Abdullah Al Masum	01621274994	( North South University ) Plot # 15, Block B, Bashundhara Residential Area, Dhaka-1229, Bangladesh		abdullahsiyam102@gmail.com	????????????	Dhaka, Bangladesh 	1	1400	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-09 19:52:51.224	2026-08-10 07:40:52.227	\N	\N	0	\N	f	ONLINE
5cfea4cb-ebb7-4c39-b8e6-d3b50af41cef	\N	\N	1735751	Adnan sami	01618845702	Uttara north sector 14 singarermor house 21		adnan22sami06@gmail.com	Dhaka	Uttara	1	3500	4480	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-08-09 20:10:31.869	2026-08-10 07:41:45.855	\N	\N	0	\N	f	ONLINE
a4d881c2-e700-4d87-a7ee-4ab2fbe657c2	\N	\N	3741411	Md. Shamim Rahman	01748399860	Thomas Tower		shamimrahman920@gmail.com	Dhaka	kakrail	2	200	156.88	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-15 10:56:44.402	2026-08-15 10:56:44.402	\N	\N	0	\N	f	ONLINE
f076faa5-4a4a-441c-be34-152dff73ee4f	\N	\N	3145661	azad	01344039940	rupatoli bosundhora housing 4 no road block A asma kunjo 			barishal sodor	rupatoli bosundhora housing ,barishal sodor kotoali thana 4 no road block A asma kunjo 	3	3300	5970	Cash on Delivery	CANCELED	\N	\N	120	f	\N	\N	2026-08-09 21:37:20.71	2026-08-10 16:06:49.848	\N	\N	0	\N	f	ONLINE
896c6dfe-1598-4647-b74c-4e91da6ada20	\N	\N	3149151	Junayed Ahmed	01805216575	Rupnagar R/A , road 16 , house 21 , mirpur ,dhaka-1216		sekkusu360@gmail.com	Dhaka	Mirpur	1	1400	2150	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-08-09 05:46:55.3	2026-08-10 07:24:45.063	\N	\N	0	\N	f	ONLINE
7ce729f7-f147-4272-b8f8-6bf650686966	\N	\N	6798481	Kazi Rukhsana Sehelin	01711086614	Ruby Razzle, House 10/A, Road 13 (Extension), Baridhara, Dhaka 1212. Beside Hotel West Valley		ruki3004@yahoo.com	Dhaka	Baridharq	2	2650	4400	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-08-09 15:04:07.225	2026-08-10 07:27:31.034	\N	\N	0	\N	f	ONLINE
79cac277-6fb2-4749-a90b-2e2b4992f671	\N	\N	3079500	Siddique Al Soyaid	01886950631	Charvatqura		siddiquealsoyaid78@gmail.com	Tangail	Dhanbari, Tangail .	1	1400	2190	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-10 01:31:38.454	2026-08-10 07:43:33.501	\N	\N	0	\N	f	ONLINE
5b8bb181-dd43-4fe9-85ee-8fce3b8def6c	\N	\N	5479200	??????????????? ???????????????	01611560891	??????????????? ???????????????, ????????????????????? ????????????, ?????????????????????		cocmasters101010@gmail.com	Jhenaidah 	??????????????? ???????????????, ????????????????????? ????????????, ?????????????????????	1	1400	2640	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-10 05:10:09.072	2026-08-10 07:45:16.722	\N	\N	0	\N	f	ONLINE
9ed2d8a7-0bf7-447d-baf3-1e0f8d690afb	\N	\N	6425821	Uddipto Islam Naireet 	01534629010	House no:988, Road no 16, Flat-4D, Baitul aman housing society,Adabor		stress470@gmail.com	Dhaka	Adabor	1	1400	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-08-10 05:15:34.604	2026-08-10 07:46:08.826	\N	\N	0	\N	f	ONLINE
5187b4f7-7082-4437-9f37-239863cbe711	\N	\N	9649821	Mahi	01305328813 	Cholklokman bismillah lodge 		istiakahmedmahi588@gmail.com	Rajshahi 	Bogura sadar	1	1500	2820	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-10 06:40:38.731	2026-08-10 07:46:42.127	\N	\N	0	\N	f	ONLINE
5289f417-3656-4cd0-8384-1bf4790214d4	\N	\N	4675860	Zannatul Ferdous Ety	01902993622	227/a Postogola Karimullahrbag Habibullah Housing Islami Bank Er Goli		hennalover99@gmail.com	Dhaka	Postogola 	1	1500	2780	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2026-08-10 14:51:40.631	2026-08-10 16:06:37.063	\N	\N	0	\N	f	ONLINE
cdf7e381-c18b-44ca-a197-e5da8ac145b0	\N	\N	5511831	Saheba Haque 	01723866008  	Darogapara 18east link road ,khulna		sahebahaqur@gmail.com	Khulna	khulna	1	1400	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-10 07:08:33.798	2026-08-10 16:08:13.003	\N	\N	0	\N	f	ONLINE
5ef35592-ff05-4ed6-bfb2-0e029ca910c7	\N	\N	7756110	AXY	000000000	AXZY			Dhaka	Dhaka	29	40600	65330	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2026-08-10 20:29:42.496	2026-08-11 06:05:12.79	\N	\N	0	\N	f	ONLINE
9299f7c3-91b4-471d-b388-83510d5d9f70	\N	\N	7497481	AXY	000000000	AXZY			Dhaka	Dhaka	2	0	5120	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2026-08-10 20:29:15.566	2026-08-11 06:05:28.123	\N	\N	0	\N	f	ONLINE
bb820205-97dc-47ab-af90-f401b9552d4c	\N	\N	0779301	Mazharul Haq	01860043267	Nitaigonj ,Naryanganj		robinvanpulok007@gmail.com	Naryanganj 	Nitaigonj, Naryanganj 	1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-11 09:05:38.316	2026-08-11 09:08:39.548	\N	\N	0	\N	f	ONLINE
341ec07c-7c02-4af6-b967-65a0a582561a	\N	\N	9130091	Evan	01680632170	kanchijhuly mosjid road mymensingh city		istiaqahmedevan@gmail.com	Mymensingh 	Kancijhuly mosjid road mymensingh 	1	1400	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-11 08:29:18.723	2026-08-11 09:09:25.643	\N	\N	0	\N	f	ONLINE
ebfa84c4-1a67-415f-a7c7-ea578a319f59	\N	\N	6624640	Masuma Sarker	01621414159	Uttara, sector-9, road-7A, house-8A		mehrabfarjis@gmail.com	Dhaka	Uttara	1	1400	2600	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-08-10 10:14:04.597	2026-08-11 09:10:00.745	\N	\N	0	\N	f	ONLINE
7351f275-b2db-4d51-8410-aea309aba38f	\N	\N	9687901	Hasib rahaman Himel	01888058357	Dhaka bashabo patowari bilding			Dhaka 	Dhaka bashabo patowari bilding 	1	1400	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-10 10:33:48.744	2026-08-11 09:10:36.763	\N	\N	0	\N	f	ONLINE
2001e88d-5187-488f-a73b-bf00464004b8	\N	\N	1641670	Nishan	01981999356	Shishupark RD		01716424783br@gmail.com	Thakurgaon	Thakurgaon Asrompara	1	1500	2190	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-10 10:36:48.098	2026-08-11 09:11:11.183	\N	\N	0	\N	f	ONLINE
57b3936b-962e-4b34-ae76-2dce30029f19	\N	\N	3526031	shahrear abir	01777858670	Floor 5, House 6, Road 137, Block SE(D), Gulshan 1, Dhaka, 1212		shahrearabir97@gmail.com	dhaka	dhaka	1	2000	2600	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-08-10 10:41:35.812	2026-08-11 09:11:52.543	\N	\N	0	\N	f	ONLINE
f0952975-1cfd-4b55-b6a1-e71b4f0b8ea4	\N	\N	6839121	Farhan Mahmood Fahim	01671080585	132/1, East Ahammadnagar, Jonaki Road, Mirpur-1		fahim05018@gmail.com	Dhaka	Mirpur-1	1	1400	2600	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-08-10 14:55:44.256	2026-08-11 09:12:23.268	\N	\N	0	\N	f	ONLINE
a22e15da-9997-4ed3-8a90-41ada72a8543	\N	\N	8135520	shariar shawon 	01603698258	upazila:Burichang village:pirjatrapur post:pirjatrapur union porishod samne jakir chairman house 		shahriarshawon1532@gmail.com	Cumilla 		1	1400	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-11 06:49:09.315	2026-08-11 09:13:04.228	\N	\N	0	\N	f	ONLINE
0c114cbb-aa49-4f06-aa06-7c70444cc6f2	\N	\N	0832181	??????:????????? ???????????????	01616754829	????????? ?????? ????????????, ?????????????????? ??????????????????,  ???????????????		jibonhss@gmail.com	Dhaka		1	3500	4480	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-08-11 06:52:02.337	2026-08-11 09:13:41.191	\N	\N	0	\N	f	ONLINE
d36fc1d4-ea33-4602-af32-2a8715cdb385	\N	\N	1143221	Alamin Jr	01792353788	Kaliakair new market shop number : 108, Kaliakair, Gazipur.		alaminjr128@gmail.com	Gazipur		1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-11 07:42:03.608	2026-08-11 09:14:14.863	\N	\N	0	\N	f	ONLINE
b14100d8-78d5-4c1b-9ccc-12fc02600bb9	\N	\N	8064800	Al Amin 	01792353788	Kaliakair new market shop number : 108, Kaliakair, Gazipur.		alaminjr128@gmail.com	Gazipur		1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-11 07:37:20.645	2026-08-11 09:14:20.214	\N	\N	0	\N	f	ONLINE
3bf72b73-437f-4044-b9bc-aaf64d074275	\N	\N	7745291	Md Sabbir	01722332127	???????????????????????? ??????????????? ?????????		mdsabbirhosaain35@gmail.com	?????????????????? ???????????? 	?????????????????? ????????? 	1	3500	4520	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-11 17:06:27.721	2026-08-12 07:22:58.317	\N	\N	0	\N	f	ONLINE
e927e229-469e-4aff-b606-c55db0a8fb55	\N	\N	8731050	Md. Sirajul Islam.	01711538990	Sonali Shwapno, House #27/2/C, Road #3, Shyamoli, Dhaka-1207.		sirajulislam820@gmail.com	Dhaka	Sher E Bangla Nagar.	1	1500	1330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-08-11 19:36:06.288	2026-08-12 07:23:07.125	\N	\N	0	\N	f	ONLINE
4bf70f72-963c-4cab-a198-8c6dbf24df71	\N	\N	7497171	Arifin Howlader	01705080386	??????????????????????????? ?????????,?????? ????????????????????? ????????????		arifinhowlader6@gmail.com	Madaripur 	Madaripur 	1	3500	5320	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-11 19:16:33.934	2026-08-12 07:23:14.823	\N	\N	0	\N	f	ONLINE
5b9cef7a-2847-46ec-b227-fa4ebd18ac6c	\N	\N	7357691	Faruk Nayerm	01760689683	Uttara sector 05, road 3a, house 17			Dhaka	Uttara	1	1000	1880	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-08-12 00:18:03.249	2026-08-12 07:23:25.9	\N	\N	0	\N	f	ONLINE
25750d5f-f90e-4c30-89ef-d085e113ac1a	\N	\N	2117160	Sihab Sumon	01886153231	Mizmizi Paschim Para High School, Siddhirganj,Narayanganj		sihabthebot53@gmail.com	Narayanganj	Mizmizi Paschim Para High School, Siddhirganj,Narayanganj	1	1400	2190	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-12 07:20:36.933	2026-08-12 13:57:14.167	\N	\N	0	\N	f	ONLINE
cbe02d74-908f-48c3-90dc-a70c92efd5a1	\N	\N	7161320	Farhan Antu	01869998697	Erad Ali Mia sarak, Kumarkhali 7010		farhanantu886@gmail.com	Kushtia	Hll Bazar, Kumarkhali, Kushtia	1	1400	2190	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-11 15:56:57.667	2026-08-12 07:22:51.095	\N	\N	0	\N	f	ONLINE
57cd841a-782e-46e7-b41d-9378028043e6	\N	\N	1945511	Uddipto Islam Naireet 	01534629010	House no 988, road no 16, Flat-4D, Baitul aman housing society, Adabor 		stress470@gmail.com	Dhaka 	Adabor 	1	1400	1560	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-12 11:15:11.357	2026-08-12 13:58:18.777	\N	\N	0	\N	f	ONLINE
17760aa9-5d8d-4db5-be03-a79973b91b12	\N	\N	5304050	Rafa Akter	01621007033	Pakistani Bazar ,khantek road uttara		habibaakterrafa@gmail.com	Dhaka	Uttara 	1	1400	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-08-12 11:19:52.078	2026-08-12 13:58:24.416	\N	\N	0	\N	f	ONLINE
2f37847e-af0c-4f78-96ec-9cc1634f4be8	\N	\N	0360070	Shafin Siddique	01716252006	Sabalia 3 Tala			Tangail Sadar	Sabalia	1	3500	5320	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2026-08-12 14:47:46.418	2026-08-12 14:47:46.418	\N	\N	0	\N	f	ONLINE
65f67027-f009-477b-879c-2da513600f1d	\N	\N	8424910	Mahbub	+8801731399128	Surma 57/a , Shuloghor 		mahbub99128@gmail.com	Sunamgonj 	Sunamgonj sadar	1	2000	2820	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-13 05:11:57.073	2026-08-13 08:54:42.587	\N	\N	0	\N	f	ONLINE
f20d0aa2-8e35-4681-8051-694bf4281524	\N	\N	3587610	Abdullah Al Faruque	01710560238	30/1 monir hossain lane shamibag opposite of shoktir gate.		havoc199090@gmail.con	Dhaka	30/1 monir hossain lane shamibag opposite of shoktir gate.	1	1400	2330	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-08-12 18:47:03.805	2026-08-13 08:55:47.117	\N	\N	0	\N	f	ONLINE
afe0e5fe-1d42-40ef-8d92-c438082d20bc	\N	\N	8310971	Mahim	+8801746605368	?????? ???????????? ????????? ??????????????? ??????????????? 			?????????????????? 	?????????????????? ???????????????????????? 	1	1250	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-12 18:38:54.245	2026-08-13 08:57:23.792	\N	\N	0	\N	f	ONLINE
5d0622f3-b533-458a-8e1c-7175fda5b3d4	\N	\N	7619870	Ibrahim Amin	1781490824	Shatghoria Holodia Louhojong Munshiganj		last.rainfall666@gmail.com	Munshiganj 		1	1000	1920	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-12 17:13:01.274	2026-08-13 08:58:40.469	\N	\N	0	\N	f	ONLINE
1a2aac6b-a3ea-4bf8-a859-d33670a3f2ce	\N	\N	1835140	adman erfan	01310265785	Station road notun bazar		admanirfan1234@gmail.com	Gazipur	Tongi	1	1400	2820	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-12 16:13:35.617	2026-08-13 08:59:28.72	\N	\N	0	\N	f	ONLINE
52cc8500-7122-4a53-9cc0-c623b94880d3	\N	\N	5788371	Ahmed siam	+8801853155133	Daudkandi		ahmedsiyam3815@gmail.com	Cumilla	Daudkandi bazar, Daudkandi 	1	1400	2370	Cash on Delivery	DELIVERED	\N	\N	120	f	\N	\N	2026-08-12 14:57:29.15	2026-08-13 09:00:15.194	\N	\N	0	\N	f	ONLINE
11e7b2ae-e2b6-460f-a390-d4d1584dac37	\N	\N	6059111	Md. Shamim Rahman	01748399860	Thomas Tower		shamimrahman920@gmail.com	Dhaka	kakrail	1	100	228.58	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-15 11:00:11.592	2026-08-15 11:00:11.592	\N	\N	0	\N	f	ONLINE
50725596-4c81-4eda-b89f-eefd3d339a57	\N	\N	1094340	Md. Shamim Rahman	01748399860	Thomas Tower		shamimrahman920@gmail.com	Dhaka	kakrail	2	200	156.88	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-15 11:41:56.858	2026-08-15 11:41:56.858	\N	\N	0	\N	f	ONLINE
0f3f9142-1a54-4bf2-a86d-5588507954cb	\N	\N	1426621	Md. Shamim Rahman	01748399860	Thomas Tower		shamimrahman920@gmail.com	Dhaka	kakrail	1	100	137.18	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-15 11:42:24.912	2026-08-15 11:42:24.912	\N	\N	0	\N	f	ONLINE
41b9327c-d15a-4eae-a8b7-30bd46f4dc18	\N	\N	6378180	Md. Shamim Rahman	01748399860	Thomas Tower			Dhaka	kakrail	12	1200	591.92	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-15 12:41:10.058	2026-08-15 12:41:10.058	\N	\N	0	\N	f	ONLINE
e9a64406-d1b7-41e1-9f09-26e6ad551901	\N	\N	5473921	Md. Shamim Rahman	01748399860	Thomas Tower			Dhaka	kakrail	4	400	442.47	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-15 15:42:39.536	2026-08-15 15:42:39.536	\N	\N	0	\N	f	ONLINE
14583cb8-d1f4-4bf6-99fd-8d2d4936d81f	\N	\N	5794301	Md. Shamim Rahman	01748399860	Thomas Tower			Dhaka	kakrail	1	100	93.9	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-15 15:43:03.109	2026-08-15 15:43:03.109	\N	\N	0	\N	f	ONLINE
1e55dcc9-e2ac-442c-a080-3fdfd1bb7cde	\N	\N	8173990	Md. Shamim Rahman	01748399860	Thomas Tower			Dhaka	kakrail	3	300	213.76	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-15 15:47:01.199	2026-08-15 15:47:01.199	\N	\N	0	\N	f	ONLINE
8237d69c-abbe-457c-ab24-43563776b76d	\N	\N	3910321	Md. Shamim Rahman	01748399860	Thomas Tower			Dhaka	kakrail	7	700	612.96	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-15 15:56:37.208	2026-08-15 15:56:37.208	\N	\N	0	\N	f	ONLINE
5263ed95-fb5a-4cbe-b5fb-2d659194b8b2	\N	\N	8203980	Md. Shamim Rahman	01748399860	Thomas Tower			Dhaka	kakrail	1	100	228.58	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-15 16:03:42.421	2026-08-15 16:03:42.421	\N	\N	0	\N	f	ONLINE
f9cff494-b6ae-4156-8408-30d8e939b2c8	\N	\N	3701400	Md. Shamim Rahman	01748399860	Thomas Tower			Dhaka	kakrail	1	100	172.26	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-15 16:12:51.942	2026-08-15 16:12:51.942	\N	\N	0	\N	f	ONLINE
393eb42b-e1a2-4544-9bf3-cdde5baf594a	\N	\N	5098591	Md. Shamim Rahman	01748399860	Thomas Tower			Dhaka	kakrail	1	100	172.26	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-15 16:15:12.287	2026-08-15 16:15:12.287	\N	\N	0	\N	f	ONLINE
a63cccf4-9f92-4a04-b2b8-4804ce30fa9a	\N	\N	7050151	Md. Shamim Rahman	01748399860	Thomas Tower			Dhaka	kakrail	1	100	103.98	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-15 16:18:28.47	2026-08-15 16:18:28.47	\N	\N	0	\N	f	ONLINE
1090d499-0f7a-43f0-83c6-3b3989e929f2	\N	\N	7860471	Md. Shamim Rahman	01748399860	Thomas Tower			Dhaka	kakrail	1	100	151.49	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-15 16:19:50.296	2026-08-15 16:19:50.296	\N	\N	0	\N	f	ONLINE
171cba4a-9a74-4f12-91af-6b3a98dd4818	\N	\N	1646321	Md. Shamim Rahman	01748399860	Thomas Tower			Dhaka	kakrail	6	600	657.79	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-15 16:26:10.653	2026-08-15 16:26:10.653	\N	\N	0	\N	f	ONLINE
4fdfbc81-2104-4b9f-990d-aa6f837422b3	\N	\N	2761820	Md. Shamim Rahman	01748399860	Thomas Tower			Dhaka	kakrail	4	400	317.27	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-15 16:27:57.998	2026-08-15 16:27:57.998	\N	\N	0	\N	f	ONLINE
8c114cfd-04b9-4f6f-9dc4-71780dc8d143	\N	\N	4549241	Md. Shamim Rahman	01748399860	Thomas Tower			Dhaka	kakrail	3	300	210.13	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-15 16:31:01.805	2026-08-15 16:31:01.805	\N	\N	0	\N	f	ONLINE
00fe8e3f-9193-4176-9bc0-cfa850172eef	\N	\N	6078171	Md. Shamim Rahman	01748399860	Thomas Tower			Dhaka	kakrail	2	200	165.39	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-15 16:33:31.975	2026-08-15 16:33:31.975	\N	\N	0	\N	f	ONLINE
b858d719-3f7d-44dd-b4fe-547d56d1976d	\N	\N	3890360	Md. Shamim Rahman	01748399860	Thomas Tower			Dhaka	kakrail	3	300	311.95	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-15 16:46:32.986	2026-08-15 16:46:32.986	\N	\N	0	\N	f	ONLINE
b25adf9e-f1a6-43b4-822a-7b6056411685	\N	\N	9602711	Md. Shamim Rahman	01748399860	Thomas Tower			Dhaka	kakrail	8	800	608.34	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-15 16:56:02.542	2026-08-15 16:56:02.542	\N	\N	0	\N	f	ONLINE
5da4cbba-7d42-467e-a013-24470ea51dd8	\N	\N	0371661	Md. Shamim Rahman	01748399860	Thomas Tower			Dhaka	kakrail	1	100	193.13	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-15 16:57:19.704	2026-08-15 16:57:19.704	\N	\N	0	\N	f	ONLINE
4e214eac-b6cf-4948-9345-6182c7028a99	\N	\N	6645730	Md. Shamim Rahman	01748399860	Thomas Tower			Dhaka	kakrail	1	100	182.88	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-15 17:41:08.028	2026-08-15 17:41:08.028	\N	\N	0	\N	f	ONLINE
131298ef-fd2b-4964-800f-7078e3acf7d3	\N	\N	5110281	Md. Shamim Rahman	01748399860	Thomas Tower			Dhaka	kakrail	5	500	428.73	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-21 12:48:34.254	2026-08-21 12:48:34.254	\N	\N	0	\N	f	ONLINE
65815bef-9a80-41f5-b917-48b8d311f54b	\N	\N	8673511	Md. Shamim Rahman	01748399860	Thomas Tower			Dhaka	kakrail	6	500	504.5	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-21 21:47:54.425	2026-08-21 21:47:54.425	\N	\N	0	\N	f	ONLINE
88facece-260d-47db-85f3-949c9a5e3741	\N	\N	8352160	Md. Shamim Rahman	01748399860	23/1, New Baily Road, Chamelibag, Kakrail, Shiddheswari, Dhaka, Dhaka Metropolitan, Dhaka District, Dhaka Division, 1217, Bangladesh		shamimrahman920@gmail.com	Dhaka District		2	100	182.98	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2026-08-22 18:20:56.394	2026-08-22 18:20:56.394	\N	\N	0	\N	f	ONLINE
af126106-ac53-4ccd-a6ad-f38fed853b08	\N	\N	8756660	Md. Shamim Rahman	01748399860	23/1, New Baily Road, Chamelibag, Kakrail, Shiddheswari, Dhaka, Dhaka Metropolitan, Dhaka District, Dhaka Division, 1217, Bangladesh, House: 2, Flat: 2, Building: 2		shamimrahman920@gmail.com	Dhaka District		1	100	228.74	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2026-08-22 18:21:22.146	2026-08-22 18:21:22.146	\N	\N	0	\N	f	ONLINE
e1d8cbce-31c4-4d5a-891c-78f77a14ccb9	\N	\N	9767220	Md. Shamim Rahman	01748399860	23/1, New Baily Road, Chamelibag, Kakrail, Shiddheswari, Dhaka, Dhaka Metropolitan, Dhaka District, Dhaka Division, 1217, Bangladesh, House: 2, Flat: 2, Building: 2		shamimrahman920@gmail.com	Dhaka District		1	100	212.26	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2026-08-22 18:39:56.778	2026-08-22 18:39:56.778	\N	\N	0	\N	f	ONLINE
1135e981-b415-4228-ba2d-958d8e1b5385	\N	\N	5494371	Md. Shamim Rahman	01748399860	85/1E, Kakrail		shamimrahman920@gmail.com	Dhaka District	Kakrail	3	300	311.95	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-22 18:49:42.19	2026-08-22 18:49:42.19	\N	\N	0	\N	f	ONLINE
6aa65740-9b39-4d93-ac6d-6a42fb51cbf2	\N	\N	6163200	Raisa maliha	01712930159	Alo Hostel		shamimrahman920@gmail.com	Sylhet District	Kakrail	2	0	373.2	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2026-08-22 18:50:54.833	2026-08-22 18:50:54.833	\N	\N	0	\N	f	ONLINE
9a48ae4f-c580-4b9a-97d2-62745477ae33	\N	\N	6985500	Shreyosi	01712930159	Kolponayoton Market		shamimrahman920@gmail.com	pabna District	Dilalpur	1	100	212.26	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2026-08-22 18:52:14.084	2026-08-22 18:52:14.084	\N	\N	0	\N	f	ONLINE
359f62cb-cbea-4c89-a51a-d3f6a94a31d8	\N	\N	0749300	Shamim Rahman	01712930159	85/1E, Kakrail, Thomas ower, Flat-2a		shamimrahman920@gmail.com	Dhaka District	kakrail	2	100	151.08	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-22 18:58:35.775	2026-08-22 18:58:35.775	\N	\N	0	\N	f	ONLINE
ce64c867-df5e-4289-bdf9-d5aa83432c19	\N	\N	3572380	Shamim Rahman	01712930159	85/1E, Kakrail, Thomas ower, Flat-2a		shamimrahman920@gmail.com	Dhaka District	kakrail	1	100	164.37	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-22 19:19:37.421	2026-08-22 19:19:37.421	\N	\N	0	\N	f	ONLINE
4b6ec7dd-1662-4ea7-819d-f7bd368d738d	\N	\N	5214261	Shamim Rahman	01712930159	85/1E, Kakrail, Thomas ower, Flat-2a		shamimrahman920@gmail.com	Dhaka District	kakrail	28	300	209.84	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-22 19:22:07.362	2026-08-22 19:22:07.362	\N	\N	0	\N	f	ONLINE
efcfe077-c0bc-4ebf-9d46-9acadc41941b	\N	\N	2444211	Shamim Rahman	01712930159	85/1E, Kakrail, Thomas ower, Flat-2a		shamimrahman920@gmail.com	Dhaka District	kakrail	6	400	374.76	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-22 20:24:07.177	2026-08-22 20:24:07.177	\N	\N	0	\N	f	ONLINE
d4e03a19-fbe3-4b62-b289-4573466797be	\N	\N	8531931	Shamim Rahman	01712930159	85/1E, Kakrail, Thomas ower, Flat-2a		shamimrahman920@gmail.com	Dhaka District	kakrail	2	100	188.74	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-22 19:11:29.414	2026-08-22 19:11:29.414	\N	\N	0	\N	f	ONLINE
5c55f383-8205-4674-bcfb-9b3411b56b22	\N	\N	4907250	Shamim	01748399860	85/1E,Thomas Tower, Kakrail,Dhaka			Dhaka District	Shiddheswari	1	100	135.75	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-22 20:28:15.124	2026-08-22 20:28:15.124	\N	\N	0	\N	f	ONLINE
96439422-fe9b-4087-8e7a-b449eb3180ae	\N	\N	7124031	Shamim Rahman	01712930159	85/1E, Kakrail, Thomas ower, Flat-2a		shamimrahman920@gmail.com	Dhaka District	kakrail	13	1100	874.0999999999999	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-23 19:51:55.486	2026-08-23 19:51:55.486	\N	\N	0	\N	f	ONLINE
2b6f8433-7381-4393-81be-dd84d42155a0	\N	\N	0032890	Md. Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	1	100	182.88	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-26 08:13:28.842	2026-08-26 08:13:28.842	\N	\N	0	\N	f	ONLINE
3d17750f-4bd7-463b-b0d1-ff045d529920	\N	\N	9668271	Md. Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	2	200	126.1225	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-26 12:06:11.758	2026-08-26 12:06:11.758	\N	\N	0	\N	f	ONLINE
ab98d4b8-12f7-42bc-af0d-7116cfac418d	\N	\N	4838331	Md. Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	1	0	200.447	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-26 16:41:29.171	2026-08-26 16:41:29.171	\N	\N	0	\N	f	ONLINE
8b7c90a5-beee-446c-929c-79c52dff4192	\N	\N	6570580	Md. Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	4	0	380.68	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-26 16:44:35.261	2026-08-26 16:44:35.261	\N	\N	0	\N	f	ONLINE
84b7775e-c994-4bcc-b22e-3b9ecb5df00b	\N	\N	9533931	Md. Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	2	0	311.37	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-26 16:49:24.26	2026-08-26 16:49:24.26	\N	\N	0	\N	f	ONLINE
66c60bce-292c-4edb-8a87-88ae7ac56da3	\N	\N	8587050	Md. Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	2	0	208.67	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-08-26 17:04:48.182	2026-08-26 17:09:37.922	\N	\N	0	\N	f	ONLINE
f0685c49-1658-4601-ab99-24627529cafc	\N	\N	3336211	Md. Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	2	0	212.17	Cash on Delivery	SHIPPED	\N	80	\N	f	\N	\N	2026-08-26 17:12:23.731	2026-08-26 17:15:49.377	\N	\N	0	\N	f	ONLINE
b5f7a8c7-a99c-40ac-b338-4bbd74ec6d82	\N	\N	7380090	Md. Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	2	0	212.17	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-26 17:18:59.667	2026-08-26 17:18:59.667	\N	\N	0	\N	f	ONLINE
e3eb1a35-e630-47f3-8069-56b22b907354	\N	\N	1513840	Md. Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	2	200	310.274	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-26 17:25:53.416	2026-08-26 17:25:53.416	\N	\N	0	\N	f	ONLINE
eeb0e227-9401-4db8-b29d-e00e889b4d34	\N	\N	0590710	Md. Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	3	0	343.829	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-26 17:57:40.672	2026-08-26 17:57:40.672	\N	\N	0	\N	f	ONLINE
9dfbafd9-b857-4e2a-b245-de7ff3c1cd75	\N	\N	9730180	Md. Shamim Rahman	01748399860	Thomas Tower, Flat-2 A 		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	3	300	329.42	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-26 18:13:16.74	2026-08-26 18:13:16.74	\N	\N	0	\N	f	ONLINE
2c37174a-38a5-4fab-9a00-164bb4578fc2	\N	\N	3179790	Md. Shamim Rahman	01748399860	Thomas Tower, Flat-2 A 		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	1	0	162.79	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-26 18:18:49.115	2026-08-26 18:18:49.115	\N	\N	0	\N	f	ONLINE
43627b5d-8b76-4446-a90d-a500f588cfd9	\N	\N	4951930	Md. Shamim Rahmant	01748399864	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	2	0	253.6	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-26 19:11:46.315	2026-08-26 19:11:46.315	\N	\N	0	\N	f	ONLINE
20060e15-cf73-490e-ac3a-cb3fc9340732	\N	\N	7235611	Shamim Rahman	01748399860	Thomas Tower, Flat-2A			Dhaka District	Kakrail	2	0	134.152	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-26 19:16:04.392	2026-08-26 19:16:04.392	\N	\N	0	\N	f	ONLINE
bf11184f-1a2f-44da-b228-a1696592b9df	\N	\N	1462180	sam	01748399860	thomas tower			Dhaka District	Ramna	3	300	365.7225	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-26 19:22:54.722	2026-08-26 19:22:54.722	\N	\N	0	\N	f	ONLINE
21ca9764-a7e1-4ac8-8dc3-e955da6c689f	\N	\N	4882070	sam	01748399860	thomas tower			Dhaka District	Ramna	1	100	189.61	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-26 19:28:13.764	2026-08-26 19:28:13.764	\N	\N	0	\N	f	ONLINE
3c48e5a0-33b2-43a4-9ca3-03e2744e94ca	\N	\N	6247211	Shamim Rahman	01748399860	Thomas Tower, Flat-2A			Dhaka District	Kakrail	4	200	423.18	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-26 19:47:09.173	2026-08-26 19:47:09.173	\N	\N	0	\N	f	ONLINE
1d0e700e-1957-4f08-854b-5cff8bdb2252	\N	\N	6661481	Shamim Rahman	01748399860	Thomas Tower, Flat-2A			Dhaka District	Kakrail	3	0	298.359	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-26 20:21:16.666	2026-08-26 20:21:16.666	\N	\N	0	\N	f	ONLINE
8aae87ae-25f3-45dc-a5e7-b65d0657eaa9	\N	\N	4907501	Maliha	01748399860	Alo hostel			Sylhet	Akahlia road	1	100	216.1605	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2026-08-26 20:52:12.523	2026-08-26 20:52:12.523	\N	\N	0	\N	f	ONLINE
b413ba1f-b51c-45d4-9c09-3e320cd6305d	\N	\N	8845191	Shamim Rahman	01748399860	Thomas Tower, Flat-2A			Dhaka District	Kakrail	5	500	386.116	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-26 21:31:40.324	2026-08-26 21:31:40.324	\N	\N	0	\N	f	ONLINE
4b07b739-4cd2-490d-8f42-84c4c422919a	\N	\N	8211680	Shamim Rahman	01748399860	Thomas Tower, Flat-2A			Dhaka District	Kakrail	3	0	389.759	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-27 02:30:23.55	2026-08-27 02:30:23.55	\N	\N	0	\N	f	ONLINE
2e92a613-ac6c-4150-b9a7-9b1147f4db75	\N	\N	4929511	Jannat	01622591127	156 Dhanmondi 			Dhaka	Dhanmondi	1	100	107.45	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-27 03:32:13.072	2026-08-27 03:32:13.072	\N	\N	0	\N	f	ONLINE
bce3f9f8-e465-4818-8d10-4da7f92e8502	\N	\N	7551541	Shamim	01748399860	city bank IT, road 113, Gulshan-2			Dhaka District	Gulshan	2	200	310.274	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-27 08:37:00.45	2026-08-27 08:37:00.45	\N	\N	0	\N	f	ONLINE
de2d6b50-b9e7-4415-81f6-5018c4509988	\N	\N	9303491	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	3	100	360.74	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-28 12:59:20.774	2026-08-28 12:59:20.774	\N	\N	0	\N	f	ONLINE
7c1b6c80-6386-48cf-94ab-b3f290253d19	\N	\N	8194741	Md. Shamim Rahmant	01748399864	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	1	100	140.537	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-28 21:33:50.729	2026-08-28 21:33:50.729	\N	\N	0	\N	f	ONLINE
c66bb1e8-48d3-49c3-aab2-ca011dfa2691	\N	\N	6680561	Shamim	01748399860	city bank IT, road 113, Gulshan-2			Dhaka District	Gulshan	1	100	183.44	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-28 22:54:38.666	2026-08-28 22:54:38.666	\N	\N	0	\N	f	ONLINE
437d8f40-ebe3-430e-a191-20356bcc54df	\N	\N	6931111	Shamim	01748399860	city bank IT, road 113, Gulshan-2			Dhaka District	Gulshan	1	100	184.76	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-28 22:55:05.718	2026-08-28 22:55:05.718	\N	\N	0	\N	f	ONLINE
39140d64-e061-418c-95d5-5b5a2bd9e9f2	\N	\N	4127941	Shamim	01748399860	city bank IT, road 113, Gulshan-2			Dhaka District	Gulshan	3	300	200.44	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-29 10:46:59.281	2026-08-29 10:46:59.281	\N	\N	0	\N	f	ONLINE
998bef41-ccbd-4c65-9087-4d4f94204bb7	\N	\N	8213911	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	2	0	167.53	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-29 19:13:44.849	2026-08-29 19:13:44.849	\N	\N	0	\N	f	ONLINE
7517dbac-534c-4e8b-9194-d30d6d81e09b	\N	\N	0813891	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	3	300	337.823	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-29 19:18:04.652	2026-08-29 19:18:04.652	\N	\N	0	\N	f	ONLINE
ba473502-9c1a-4e73-b7a7-160659bba3fe	\N	\N	4739200	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	2	0	308.83	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-30 19:34:38.708	2026-08-30 19:34:38.708	\N	\N	0	\N	f	ONLINE
e15ae015-e9b9-44c6-8dc2-0bc47b066029	\N	\N	6266740	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	1	100	128.37	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-01 10:47:13.643	2026-09-01 10:47:13.643	\N	\N	0	\N	f	ONLINE
adb64b02-160b-466b-8495-b71dbfd3ca3a	\N	\N	4197300	Md. Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	1	0	103.43	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-26 17:30:21.336	2026-08-26 17:30:21.336	\N	\N	0	\N	f	ONLINE
51ddf7c6-2cb7-4ef9-9ed3-55d8911c3574	\N	\N	2417801	Md. Shamim Rahman	01748399860	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	2	100	160.61	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-26 18:00:44.556	2026-08-26 18:00:44.556	\N	\N	0	\N	f	ONLINE
e43799bd-445e-471b-9f56-a74a3b46f80d	\N	\N	9757681	Shamim Rahman	01748399860	Thomas Tower, Flat-2A			Dhaka District	Kakrail	7	300	285.2915	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-26 19:19:41.358	2026-08-26 19:19:41.358	\N	\N	0	\N	f	ONLINE
037663e7-12a0-45f3-ba82-0ed197f6e54b	\N	\N	7454071	Shamim Rahman	01748399860	Thomas Tower, Flat-2A			Dhaka District	Kakrail	3	0	207.04	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-26 19:32:29.32	2026-08-26 19:32:29.32	\N	\N	0	\N	f	ONLINE
5adb25d7-9b23-43ca-8dfb-c42121526a21	\N	\N	9074131	Shamim Rahman	01748399860	Thomas Tower, Flat-2A			Dhaka District	Kakrail	12	0	249.482	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-26 19:35:26.391	2026-08-26 19:35:26.391	\N	\N	0	\N	f	ONLINE
434d0a17-b7da-4d92-8a3b-770789b93d0d	\N	\N	6916080	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	5	0	294.332	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-08-29 10:51:36.378	2026-08-29 10:51:36.378	\N	\N	0	\N	f	ONLINE
80a1c489-ae2d-4d13-9cf2-03a5766e07d2	\N	\N	2051151	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	4	400	284.21	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-01 19:16:49.453	2026-09-01 19:16:49.453	\N	\N	0	\N	f	ONLINE
89ae550b-978e-454e-88ba-77763e56cfd9	\N	\N	4322490	Md. Shamim Rahmant	01748399864	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	1	100	192.67	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-01 19:20:33.862	2026-09-01 19:20:33.862	\N	\N	0	\N	f	ONLINE
c7f9029c-0b37-430a-ba53-5b1cabce4058	\N	\N	7811240	Md. Shamim Rahman	01732256642	Thomas Tower, Flat-2 A 		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	2	2279	2862	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2026-09-02 09:19:58.973	2026-09-02 09:23:31.321	\N	\N	0	2862	f	ONLINE
013f4e16-4370-4d9e-845d-a2486790bd31	\N	\N	1256251	shamim	01732256642	Thomas Tower, Flat-2 A 			Dhaka District	Shiddheswari	2	2490	3114	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-02 10:16:11.115	2026-09-02 10:16:11.115	\N	\N	0	3114	f	ONLINE
f95c1f71-92c3-4e1d-9a23-94e5b9634bd7	\N	\N	7078751	shamim	01732256642	Thomas Tower, Flat-2 A 			Dhaka District	Shiddheswari	3	2234	2532.8	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-02 11:48:37.413	2026-09-02 11:48:37.413	\N	\N	0	\N	f	ONLINE
34f96b70-19d6-45d5-bed5-f2b4cb901b63	\N	\N	9166980	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	2	0	1396	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-02 12:08:41.847	2026-09-02 12:08:41.847	\N	\N	0	\N	f	ONLINE
7317fef4-aa57-41ab-bc9c-2a23542c2430	\N	\N	8602831	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	4	5406	4642	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-02 12:24:27.058	2026-09-02 12:24:27.058	\N	\N	0	\N	f	ONLINE
d412fba6-fb99-4e15-a03a-9a24a48b4d20	\N	\N	3341331	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	2	2738	2592	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-02 12:49:00.14	2026-09-02 12:49:00.14	\N	\N	0	\N	f	ONLINE
7b1f813a-bc8b-473a-b108-9cbba0f71028	\N	\N	4538441	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	2	1309	2938	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-02 12:50:59.027	2026-09-02 12:50:59.027	\N	\N	0	\N	f	ONLINE
c17d0ab1-f617-40a1-b0d3-28d097ffeae0	\N	\N	5957790	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	4	5038	4513.5	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-02 12:53:22.842	2026-09-02 12:53:22.842	\N	\N	0	\N	f	ONLINE
37464373-1363-4b42-878f-3ce52f1b6459	\N	\N	0744951	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	2	2783	4232	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-02 13:01:22.316	2026-09-02 13:01:22.316	\N	\N	0	\N	f	ONLINE
36d72608-2bcc-4b50-97e4-e84af0ecd28a	\N	\N	1501570	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	2	2319	3201	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-02 13:02:36.022	2026-09-02 13:02:36.022	\N	\N	0	\N	f	ONLINE
652fd53e-6f08-413b-b28d-28e88b95e4b2	\N	\N	0953920	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	2	2599	3128	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-02 20:15:04.037	2026-09-02 20:15:04.037	\N	\N	0	\N	f	ONLINE
8f60913b-6b81-4f6d-826c-3d2013a0c0e5	\N	\N	0127550	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	2	0	2101.8	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 10:33:37.656	2026-09-04 10:33:37.656	\N	\N	0	\N	f	ONLINE
12e95afe-aeea-4878-955c-2ed27d59a64c	\N	\N	0546441	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	1	1429	981.8	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 10:34:17.318	2026-09-04 10:34:17.318	\N	\N	0	\N	f	ONLINE
2b09c4e7-a70c-4d5b-b2b5-b8117759047c	\N	\N	0794920	shamim	01732256642	Thomas Tower, Flat-2 A 			Dhaka District	Shiddheswari	2	2845	3385	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 10:34:44.326	2026-09-04 10:34:44.326	\N	\N	0	\N	f	ONLINE
9b685940-c99b-451e-8457-a01813ee10f7	\N	\N	2956340	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	3	0	4924	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 10:54:59.091	2026-09-04 10:54:59.091	\N	\N	0	\N	f	ONLINE
49b570a6-a42d-4046-8972-edd258f4acf6	\N	\N	9229270	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	1	942	2706	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 11:05:25.111	2026-09-04 11:05:25.111	\N	\N	0	\N	f	ONLINE
da7aeba7-500b-4ceb-979c-80557b3c4105	\N	\N	9614330	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	1	1219	1728.8	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 11:06:03.75	2026-09-04 11:06:03.75	\N	\N	0	\N	f	ONLINE
c26d8884-fd92-4122-b443-7d9de76cc69c	\N	\N	1363381	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	1	1309	1690	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 11:08:58.587	2026-09-04 11:08:58.587	\N	\N	0	\N	f	ONLINE
d53e0f98-8255-4860-ab0c-1f739ea9cc20	\N	\N	0262700	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	4	5167	4018.8	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 11:57:09.165	2026-09-04 11:57:09.165	\N	\N	0	\N	f	ONLINE
55a2730f-3e72-421d-85de-67ead7b8cc04	\N	\N	1291131	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	1	783	2279	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 11:58:53.054	2026-09-04 11:58:53.054	\N	\N	0	\N	f	ONLINE
b937c375-406f-463e-a77c-d9a3c15bf054	\N	\N	5515330	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	6	987	1244	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 13:12:33.789	2026-09-04 13:12:33.789	\N	\N	0	\N	f	ONLINE
d9f8a02a-752b-4ca8-b99f-70c3bb6353c7	\N	\N	5522921	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	4	4874	4558	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 14:19:15.779	2026-09-04 14:19:15.779	\N	\N	0	\N	f	ONLINE
daab1929-54c9-4686-a889-f4a13fc8fe6d	\N	\N	5906981	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	1	1370	1079.2	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 15:43:13.292	2026-09-04 15:43:13.292	\N	\N	0	\N	f	ONLINE
3d06e0da-dd31-4415-8336-3b3797157f69	\N	\N	7718910	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	5	3708	3991	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 19:39:49.694	2026-09-04 19:39:49.694	\N	\N	0	\N	f	ONLINE
2a4545f0-8546-4b47-a50b-1f603057e94b	\N	\N	8649411	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	1	1020	2614.4	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 19:41:07.941	2026-09-04 19:41:07.941	\N	\N	0	\N	f	ONLINE
f01d4cfa-4bda-45bc-b5a4-531eceb781a7	\N	\N	9178810	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	2	2353	2851	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 19:41:59.941	2026-09-04 19:41:59.941	\N	\N	0	\N	f	ONLINE
181c7953-c421-44f1-9685-3409472e1fd1	\N	\N	9760431	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	10	8050	19192	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 19:42:58.176	2026-09-04 19:42:58.176	\N	\N	0	\N	f	ONLINE
d21854e3-06a7-4ec2-ad09-bf398da45bac	\N	\N	0003551	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	12	9660	23014.4	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 19:43:22.303	2026-09-04 19:43:22.303	\N	\N	0	\N	f	ONLINE
f62d2efe-310a-42e2-8e1c-4b7124e67c89	\N	\N	7991211	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	1	1064	1580	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-05 07:53:22.108	2026-09-05 07:53:22.108	\N	\N	0	\N	f	ONLINE
157d2a03-90ff-4159-8325-958c969a0f01	\N	\N	3262860	Md. Shamim Rahmant	01748399864	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	4	4819	5329	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-05 10:48:49.228	2026-09-05 10:48:49.228	\N	\N	0	\N	f	ONLINE
034e527e-f857-4531-af2a-632b68b942c7	\N	\N	2337270	Md. Shamim Rahman	01732256642	Thomas Tower, Flat-2 A 		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	2	2490	3114	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2026-09-02 09:27:16.3	2026-09-02 09:27:41.788	\N	\N	0	3114	f	ONLINE
56a202bb-a7cd-42d3-9e02-91b114f81952	\N	\N	0299750	Md. Shamim Rahman	01732256642	Thomas Tower, Flat-2 A 		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	4	4320	7189	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2026-09-02 09:23:55.429	2026-09-02 09:27:48.064	\N	\N	0	7189	f	ONLINE
ba88e11b-da84-48a0-aa23-f919ad8d0df9	\N	\N	3118251	Md. Shamim Rahman	01732256642	Thomas Tower, Flat-2 A 		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	3	3475	4368	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2026-09-02 09:28:35.715	2026-09-02 09:29:01.021	\N	\N	0	4368	f	ONLINE
03784ffc-05bb-4594-a8aa-fbbf570f5cea	\N	\N	4993500	Md. Shamim Rahman	01732256642	Thomas Tower, Flat-2 A 		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	1	1429	1076	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-02 09:32:01.823	2026-09-02 09:32:01.823	\N	\N	0	1076	f	ONLINE
bf7f9f12-3b8b-4d4f-86fa-1abd949ba308	\N	\N	5435721	Md. Shamim Rahman	01732256642	Thomas Tower, Flat-2 A 		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	1	1426	1614	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-02 09:33:12.65	2026-09-02 09:33:12.65	\N	\N	0	1614	f	ONLINE
9e1d0d91-8e6c-4ec0-bb63-e1553f0cbc6b	\N	\N	6841250	shamim	01732256642	Thomas Tower, Flat-2 A 			Dhaka District	Shiddheswari	2	2660	4291	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-02 09:35:24.514	2026-09-02 09:35:24.514	\N	\N	0	4291	f	ONLINE
b6bf9725-71b4-48d6-9c9b-e617195e5395	\N	\N	7579121	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	3	4275	5955	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-02 12:39:25.953	2026-09-02 12:39:25.953	\N	\N	0	\N	f	ONLINE
59056eeb-dbf4-4bf3-95b8-140b395ee254	\N	\N	1256660	shamim	01732256642	Thomas Tower, Flat-2 A 			Dhaka District	Shiddheswari	2	0	3114	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 10:35:28.215	2026-09-04 10:35:28.215	\N	\N	0	\N	f	ONLINE
ed01dd64-bdd2-40b7-8070-759028607972	\N	\N	2707610	Md. Shamim Rahmant	01748399864	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	2	0	2400.7	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 10:37:52.966	2026-09-04 10:37:52.966	\N	\N	0	\N	f	ONLINE
58ffce13-7528-4201-a4f9-90c847c71a24	\N	\N	3515470	Shamim	01748399860	city bank IT, road 113, Gulshan-2			Dhaka District	Gulshan	3	3430	4399	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 10:55:54.182	2026-09-04 10:55:54.182	\N	\N	0	\N	f	ONLINE
5ec18082-7cdb-4226-b244-64d392703212	\N	\N	8374310	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	2	0	2480	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 11:04:00.115	2026-09-04 11:04:00.115	\N	\N	0	\N	f	ONLINE
ca80c0cf-61bd-4ad1-bab4-22ae78ea249e	\N	\N	8740441	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	2	0	3618	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 11:04:36.019	2026-09-04 11:04:36.019	\N	\N	0	\N	f	ONLINE
9cbb1dd6-4aa9-47f0-bef0-a699ac24441f	\N	\N	8904801	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	1	1429	981.8	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 11:04:53.926	2026-09-04 11:04:53.926	\N	\N	0	\N	f	ONLINE
721b2643-d4b9-42da-b549-628555296389	\N	\N	5821201	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	1	1196	1586	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-04 14:19:49.441	2026-09-04 14:19:49.441	\N	\N	0	\N	f	ONLINE
4b692bf5-96cc-4ede-8321-23b7282120d4	\N	\N	7911621	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	6	6226	8900.7	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-05 11:29:55.56	2026-09-05 11:29:55.56	\N	\N	0	\N	f	ONLINE
a1cc1228-8d7c-4367-9840-e4607d9899dc	\N	\N	3516750	Md. Shamim Rahmant	01748399864	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	25	0	3114	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-05 12:12:33.705	2026-09-05 12:12:33.705	\N	\N	0	\N	f	ONLINE
3c00c9fe-9b7f-4359-992c-6bcbc905baf8	\N	\N	4539461	Md. Shamim Rahmant	01748399864	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	4	0	5002.6	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-05 12:14:15.453	2026-09-05 12:14:15.453	\N	\N	0	\N	f	ONLINE
e33c42f1-2fcd-4ccf-b4e6-04e29f1888d0	\N	\N	3627751	Md. Shamim Rahman	01732256642	Thomas Tower, Flat-2 A 		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	2	2115	2946	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-02 09:29:27.062	2026-09-02 09:29:27.062	\N	\N	0	2946	f	ONLINE
3f7c154f-4347-4bdd-96e8-b9d42cd71a00	\N	\N	5604690	Md. Shamim Rahmant	01748399864	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	70	2212	4655	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-05 12:16:03.018	2026-09-05 12:16:03.018	\N	\N	0	\N	f	ONLINE
21bb7d67-c7c8-479e-80c4-dc340dc68807	\N	\N	2244540	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	1	1429	981.8	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-05 14:40:27.214	2026-09-05 14:40:27.214	\N	\N	0	\N	f	ONLINE
ed3335b1-4502-4ef7-9311-e1244c14d5b8	\N	\N	0997400	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	2	1724	2836	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-06 20:05:02.821	2026-09-06 20:05:02.821	\N	\N	0	\N	f	ONLINE
3ecc681f-14be-4619-80f5-8209798f8420	\N	\N	1058760	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	2	2234	2893	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-07 20:48:29.229	2026-09-07 20:48:29.229	\N	\N	0	\N	f	ONLINE
beed6038-b5be-48e6-aa70-86442c353808	\N	\N	4264810	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	1	805	1991.2	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-11 11:50:29.427	2026-09-11 11:50:29.427	\N	\N	0	\N	f	ONLINE
6e5e0909-190f-44f3-bd1a-8128f2ebb092	\N	\N	4642091	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	4	2127	6089.7	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-11 11:51:06.547	2026-09-11 11:51:06.547	\N	\N	0	\N	f	ONLINE
846e9d19-aeb1-425f-b863-7c2991f67241	\N	\N	1499670	Md. Shamim Rahmant	01748399864	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	5	2670	6791	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-11 18:42:32.2	2026-09-11 18:42:32.2	\N	\N	0	\N	f	ONLINE
79e53282-09e9-4c4e-a494-3a3fb4362b6d	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	7lw3J0	\N	\N	\N	\N	\N	\N	\N	7	8672	15307.2	CASH	DELIVERED	\N	\N	\N	f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	2026-09-12 11:14:06.284	2026-09-12 11:14:06.284	\N	\N	15307.2	0	t	ONLINE
02e7206a-5197-46ee-9630-11146ac63f2f	\N	\N	6464771	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	1	809	1328	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-14 19:04:09.874	2026-09-14 19:04:09.874	\N	\N	0	\N	f	ONLINE
75503b85-8f59-467c-82a8-5007925e04dc	\N	\N	0541320	Md. Shamim Rahmant	01748399864	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	1	0	1580	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-17 08:00:58.001	2026-09-17 08:00:58.001	\N	\N	0	\N	f	ONLINE
595dc41d-0a40-4144-9b65-d7bcfab11191	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	2ECG_i	Walking Customer	N/A	\N	\N	\N	\N	\N	95	103255	170255	CASH	DELIVERED	\N	\N	\N	f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	2026-09-14 17:55:45.215	2026-09-14 17:55:45.215	\N	\N	170255	0	t	OFFLINE
2363be78-d5af-45a6-ac5d-00052091b5c7	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	ztsL7H	Walking Customer	N/A	\N	\N	\N	\N	\N	3	3663	7106.4	CASH	DELIVERED	\N	\N	\N	f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	2026-09-14 17:59:50.435	2026-09-14 17:59:50.435	\N	\N	7106.4	0	t	OFFLINE
d2ed585a-1c60-4a7c-afdf-a62f04b91785	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	vLbTzY	Walking Customer	N/A	\N	\N	\N	\N	\N	4	4417	6462.1	CASH	DELIVERED	\N	\N	\N	f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	2026-09-14 18:19:21.925	2026-09-14 18:19:21.925	\N	\N	6462.1	0	t	OFFLINE
c8c30c28-80b6-4c0b-91f7-d668f28ec034	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	IJjh-4	Walking Customer	N/A	\N	\N	\N	\N	\N	4	3688	7000	CASH	DELIVERED	\N	\N	\N	f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	2026-09-17 14:44:15.425	2026-09-17 14:44:15.425	\N	\N	7000	0	t	OFFLINE
c0d387a9-9670-4d6b-b109-da58cf7b74ef	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	YghhNK	Walking Customer	N/A	\N	\N	\N	\N	\N	8	7940	16000.8	CASH	DELIVERED	\N	\N	\N	f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	2026-09-17 14:59:11.487	2026-09-17 14:59:11.487	\N	\N	16000.8	0	t	OFFLINE
ff722c28-51d2-40c6-9870-bcc2e360520a	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	SzRsEY	Walking Customer	N/A	\N	\N	\N	\N	\N	9	8488	14000.4	BKASH	DELIVERED	\N	\N	\N	f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	2026-09-18 17:41:32.67	2026-09-18 17:41:32.67	\N	\N	14000.4	0	t	OFFLINE
ab51c208-653a-4550-98da-b495fa2f02b9	\N	\N	4126201	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	2	2736	2196	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2026-09-10 17:46:56.265	2026-09-18 18:27:42.706	\N	\N	0	\N	f	ONLINE
facc6cee-f7c2-45a8-a0fe-9835c27b11a2	\N	\N	2636681	Md. Shamim Rahmant	01748399864	Nasir Tower, Flat-2A		shamimrahman920@gmail.com	Dhaka District	Kakrail	2	0	3114	Cash on Delivery	CANCELED	\N	80	\N	f	\N	\N	2026-09-18 18:31:26.715	2026-09-18 18:56:20.339	\N	\N	0	\N	f	ONLINE
63fe13d6-18a1-449f-9b56-37f0bf55d8d6	\N	\N	1722710	Md. Shamim Rahmant	01748399864	85/1E, Kakrail, Thomas Tower		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	2	1474	1178	Cash on Delivery	RETURNED	\N	80	\N	f	\N	\N	2026-09-18 18:30:13.479	2026-09-18 19:49:27.712	\N	\N	0	\N	f	ONLINE
c8becc65-99a8-48a9-a454-20143593ce85	\N	\N	0978260	Md. Shamim Rahmant	01748399864	Nasir Tower, Flat-2A		shamimrahman920@gmail.com	Dhaka District	Kakrail	1	1064	1580	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-09-18 19:51:41.071	2026-09-18 19:53:50.974	\N	\N	0	\N	f	ONLINE
085d1d0c-b733-46bc-807f-2854dcc569bb	\N	\N	0419900	Shamim Rahman	01748399860	thomas tower		shamimrocky801@yahoo.com	Dhaka District	Ramna	4	4904	5497	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-21 08:07:26.255	2026-09-21 08:07:26.255	\N	\N	0	\N	f	ONLINE
0618d753-dd38-4383-9673-ef76320b340f	\N	\N	9168151	Shamim Rahman	01748399860	113/1A		shamimrocky801@yahoo.com	dhaka	gulshan	1	1376	1764	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-29 11:39:18.403	2026-09-29 11:39:18.403	\N	\N	0	\N	f	ONLINE
922af033-7ea0-47b1-b95d-0fa9541a971f	\N	\N	7455620	Shamim Rahman	01748399860	113/1A		shamimrocky801@yahoo.com	dhaka	gulshan	1	1236	1563	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-30 15:39:08.359	2026-09-30 15:39:08.359	\N	\N	0	\N	f	ONLINE
3040e0ef-3b77-413e-aa8d-0edb3b1a9ece	\N	\N	3378950	Md. Shamim Rahmant	01748399864	85/1E, Kakrail, Thomas Tower		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	1	711	1925.35	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-09-30 19:09:04.9	2026-09-30 19:09:04.9	\N	\N	0	\N	f	ONLINE
1166093f-31d7-4e5e-aaf1-f782b40567bf	\N	\N	0019761	Shamim Rahman	01748399860	113/1A		shamimrocky801@yahoo.com	dhaka	gulshan	2	1649	2736.7	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-01 10:20:10.758	2026-10-01 10:20:10.758	\N	\N	0	\N	f	ONLINE
b9d0d030-f767-4afd-b885-77e849b5e9be	\N	\N	4754761	Md. Shamim Rahmant	01748399864	85/1E, Kakrail, Thomas Tower		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	1	1407	2743.8	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-04 18:11:18.898	2026-10-04 18:11:18.898	\N	\N	0	\N	f	ONLINE
57021b21-737e-4a53-bc17-39b475f76d79	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	rkvlbj	Walking Customer	N/A	\N	\N	\N	\N	\N	94	104106	204441.8	CASH	DELIVERED	\N	\N	\N	f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	2026-10-09 11:16:53.312	2026-10-09 11:16:53.312	\N	\N	204441.8	0	t	OFFLINE
50023eed-5f12-4230-a73e-c38db063b0c5	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	PMdrGN	Walking Customer	N/A	\N	\N	\N	\N	\N	21	23043	40796.2	BKASH	DELIVERED	\N	\N	\N	f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	2026-10-09 17:49:39.495	2026-10-09 17:49:39.495	\N	\N	40796.2	0	t	OFFLINE
aea4454f-1dce-4988-a8fd-9e4b6ccceb06	\N	\N	0248221	Md. Shamim Rahmant	01748399864	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	8	10060	10472.8	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-10-09 11:57:10.746	2026-10-09 17:50:25.991	\N	\N	0	\N	f	ONLINE
9e886823-8a2b-448b-881d-62f8c3ddea16	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	CO3fpl	Walking Customer	N/A	\N	\N	\N	\N	\N	12	13960	24000	BKASH	DELIVERED	\N	\N	\N	f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	2026-10-09 20:43:19.231	2026-10-09 20:43:19.231	\N	1245675771	24000	0	t	OFFLINE
c543a264-d26d-4411-aec3-2090c6d9add1	\N	\N	5060000	Md. Shamim Rahmant	01748399864	Nasir Tower, Flat-2A		shamimrahman920@gmail.com	Dhaka District	Kakrail	2	2750	2229	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-10 10:35:08.396	2026-10-10 10:35:08.396	\N	\N	0	\N	f	ONLINE
8fbd31b2-88b5-48d0-a0a1-7938bad73cf5	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	OvhX5v	\N	\N	\N	\N	\N	\N	\N	4	4456	8420	CASH	DELIVERED	\N	\N	\N	f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	2026-09-12 11:20:49.801	2026-09-12 11:20:49.801	\N	\N	8420	0	t	ONLINE
d0a1078d-a4bf-49be-9c22-5f56b2372287	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	qdbM-G	Walking Customer	N/A	\N	\N	\N	\N	\N	15	13787	37000	CASH	DELIVERED	\N	\N	\N	f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	2026-09-12 11:36:51.441	2026-09-12 11:36:51.441	\N	\N	37000	0	t	OFFLINE
f575f739-713c-4c31-bb62-67c89da7b0b6	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	C-dXEr	Walking Customer	N/A	\N	\N	\N	\N	\N	6	6811	11000.8	BKASH	DELIVERED	\N	\N	\N	f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	2026-09-14 18:31:43.703	2026-09-14 18:31:43.703	\N	\N	11000.8	0	t	OFFLINE
de81c463-37b7-4564-9144-b8c2faee4f96	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	dTDElb	Walking Customer	N/A	\N	\N	\N	\N	\N	2	2546	3500	NAGAD	DELIVERED	\N	\N	\N	f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	2026-09-18 18:06:24.389	2026-09-18 18:06:24.389	\N	\N	3500	0	t	OFFLINE
2cd4c057-66ca-4fe8-8538-88af1383fc62	\N	\N	7170340	Md. Shamim Rahmant	01748399864	Kakrail		shamimrahman920@gmail.com	Dhaka District	Shiddheswari	5	2670	6618	Cash on Delivery	DELIVERED	\N	80	\N	f	\N	\N	2026-10-09 20:45:21.218	2026-10-10 10:36:28.675	\N	\N	0	\N	f	ONLINE
e89394c3-db93-4215-b201-2d491a8f8261	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	Pfg9ge	Walking Customer	N/A	\N	\N	\N	\N	\N	7	7951	15000	CASH	DELIVERED	\N	\N	\N	f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	2026-10-10 13:22:19.935	2026-10-10 13:22:19.935	\N	\N	15000	0	t	OFFLINE
17d291d2-86c7-43b6-a2f7-c704f1789d88	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	ba4Q6r	Walking Customer	N/A	\N	\N	\N	\N	\N	4	4572	8486	CASH	DELIVERED	\N	\N	\N	f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	2026-10-10 13:26:43.218	2026-10-10 13:26:43.218	\N	\N	8486	0	t	OFFLINE
1a1d4100-fc5b-49b7-8d59-541225460fe4	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	lx3xly	Walking Customer	N/A	\N	\N	\N	\N	\N	5	5274	10000.4	CASH	DELIVERED	\N	\N	\N	f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	2026-09-12 11:43:33.997	2026-09-12 11:43:33.997	\N	\N	10000.4	0	t	OFFLINE
cbb508d6-e4c9-4ffa-b3f0-42dcd9a4deec	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	wYkMwc	Walking Customer	N/A	\N	\N	\N	\N	\N	8	8394	15000.2	CASH	DELIVERED	\N	\N	\N	f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	2026-09-12 11:45:19.478	2026-09-12 11:45:19.478	\N	\N	15000.2	0	t	OFFLINE
da66ee00-2b56-4578-b413-ba0f4983cdd4	\N	\N	8743860	Shamim Rahman	01748399860	teat			Dhaka District	Gulshan	1	0	1580	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-12 10:28:38.181	2026-10-12 10:28:38.181	\N	\N	0	\N	f	ONLINE
433522c8-0733-4b60-8745-c1807033d5bf	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	sAhQVE	Walking Customer	N/A	\N	\N	\N	\N	\N	5	5214	8000	CASH	DELIVERED	\N	\N	\N	f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	2026-10-16 12:42:13.959	2026-10-16 12:42:13.959	\N	\N	8000	0	t	OFFLINE
89706166-c843-431d-a5f5-0a5bbf98a719	\N	\N	3498260	shamim	01748399860	kolponayton market		shamimrocky801@yahoo.com	Pabna District	mohila college road	2	2608	2615.8	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2026-10-16 14:52:34.66	2026-10-16 14:52:34.66	\N	\N	0	\N	f	ONLINE
56c3dda6-fd90-4507-bc88-b36d60c61a19	\N	\N	0233671	Md. Shamim Rahmant	01748399864	Nasir Tower, Flat-2A		shamimrahman920@gmail.com	Dhaka District	Kakrail	1	1234	1153	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-18 17:20:28.982	2026-10-18 17:20:28.982	\N	\N	0	\N	f	ONLINE
ef4a1f15-62b1-420d-a687-832aece4a1b5	\N	\N	0729051	shamim	01732256642	Thomas Tower, Flat-2 A 			Dhaka District	Shiddheswari	2	0	990	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-22 21:37:59.858	2026-10-22 21:37:59.858	\N	\N	0	\N	f	ONLINE
a408c287-8a11-4e86-bd70-cddad35abf2f	\N	\N	4703420	shamim	01732256642	Thomas Tower, Flat-2 A 			Dhaka District	Shiddheswari	2	0	1614	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-22 21:44:32.925	2026-10-22 21:44:32.925	\N	\N	0	\N	f	ONLINE
ca566eec-0b08-4efb-a6ca-522e25d91640	\N	\N	5690630	Md. Shamim Rahmant	01748399864	Nasir Tower, Flat-2A		shamimrahman920@gmail.com	Dhaka District	Kakrail	1	1078	2542	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-23 08:52:52.392	2026-10-23 08:52:52.392	\N	\N	0	\N	f	ONLINE
6a610267-759a-41a6-9cce-9d483d83ae26	\N	\N	0513330	shamim	01732256642	Thomas Tower, Flat-2 A 			Dhaka District	Shiddheswari	1	1474	1178	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-23 09:34:19.458	2026-10-23 09:34:19.458	\N	\N	0	\N	f	ONLINE
e403052d-2578-4f90-9af6-5f42933a5e3d	\N	\N	2408660	shamim	01732256642	Thomas Tower, Flat-2 A 			Dhaka District	Shiddheswari	1	1426	1614	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-23 11:17:23.626	2026-10-23 11:17:23.626	\N	\N	0	\N	f	ONLINE
4e2f3b34-bf84-4bde-8b39-59856d1116f4	\N	\N	6878331	shamim	01732256642	Thomas Tower, Flat-2 A 			Dhaka District	Shiddheswari	1	0	1580	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-23 12:31:31.669	2026-10-23 12:31:31.669	\N	\N	0	\N	f	ONLINE
591cf74a-7581-41db-bc37-118f9155f66e	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	cKD690	Walking Customer	N/A	\N	\N	\N	\N	\N	6	5768	11000.8	CASH	DELIVERED	\N	\N	\N	f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	2026-09-12 11:44:13.212	2026-09-12 11:44:13.212	\N	\N	11000.8	0	t	OFFLINE
2a1634a4-0f91-4c5d-a178-433ddc348aaa	\N	\N	5722640	shamim	01748399860	kolponayton market		shamimrocky801@yahoo.com	Pabna District	mohila college road	7	7033	9431	Cash on Delivery	PENDING	\N	\N	120	f	\N	\N	2026-10-16 12:43:33.997	2026-10-16 12:43:33.997	\N	\N	0	\N	f	ONLINE
36ac69bc-6182-4587-94b4-ac20b431db6d	\N	\N	1187101	shamim	01732256642	Thomas Tower, Flat-2 A 			Dhaka District	Shiddheswari	2	1474	2250.7	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-23 09:52:00.476	2026-10-23 09:52:00.476	\N	\N	0	\N	f	ONLINE
dfcb47dd-1ded-427d-9a4a-144adfe06189	\N	\N	7159490	shamim	01732256642	Thomas Tower, Flat-2 A 			Dhaka District	Shiddheswari	2	0	3148	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-23 11:25:17.991	2026-10-23 11:25:17.991	\N	\N	0	\N	f	ONLINE
46a47c1a-255f-4d9f-a94e-70d0dca0a51b	\N	\N	1989021	shamim	01732256642	Thomas Tower, Flat-2 A 			Dhaka District	Shiddheswari	1	1500	2030	Cash on Delivery	SHIPPED	\N	80	\N	f	\N	\N	2026-10-24 09:30:01.748	2026-10-24 17:44:36.558	\N	\N	0	\N	f	ONLINE
89daffdd-a659-4591-8f21-3cf87249a260	\N	\N	7241221	shamim	01732256642	Thomas Tower, Flat-2 A 			Dhaka District	Shiddheswari	6	1500	1835	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-24 18:15:31.539	2026-10-24 18:15:31.539	\N	\N	0	\N	f	ONLINE
e1acc2da-17f9-45f5-9285-5a0dca3aa086	\N	\N	8371680	shamim	01732256642	Thomas Tower, Flat-2 A 			Dhaka District	Shiddheswari	1	1500	1835	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-24 18:17:19.696	2026-10-24 18:17:19.696	\N	\N	0	\N	f	ONLINE
567259ba-aaf3-49ac-9922-dc07665bea50	\N	\N	3933811	shamim	01732256642	Thomas Tower, Flat-2 A 			Dhaka District	Shiddheswari	2	1890	2690	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-24 20:23:16.369	2026-10-24 20:23:16.369	\N	\N	0	\N	f	ONLINE
b359ea0c-916c-45d2-a57d-4b3dbf5f5fd0	\N	\N	7634371	Shamim Rahman	01748399860	test		shamimrocky801@yahoo.com	Dhaka District	Ramna	1	510	1268	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-25 19:49:45.515	2026-10-25 19:49:45.515	\N	\N	0	\N	f	ONLINE
594268d3-f162-4e92-8b3b-8ba16ac4deed	\N	\N	0368351	Shamim Rahman	01748399860	test		shamimrocky801@yahoo.com	Dhaka District	Ramna	3	1540	3545	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-25 19:53:59.445	2026-10-25 19:53:59.445	\N	\N	0	\N	f	ONLINE
362d02fb-4ed7-4972-8cc5-8e3fe904705d	\N	\N	1157410	Md. Shamim Rahman	01748399860	Kakrail		clothingbrandstrike@gmail.com	Dhaka District	Shiddheswari	2	770	1763	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-25 19:55:30.829	2026-10-25 19:55:30.829	\N	\N	0	\N	f	ONLINE
d2e9f146-4536-4a5b-b4b3-bbabf02b92f4	\N	\N	7117010	Shamim Rahman	01748399860	kakrail		shamimrocky801@yahoo.com	Dhaka District	Ramna	1	1000	2580	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-26 07:11:59.313	2026-10-26 07:11:59.313	\N	\N	0	\N	f	ONLINE
caff7545-fec0-45b4-a840-286f7841a85c	\N	\N	4425970	Shamim Rahman	01748399860	kakrail		shamimrocky801@yahoo.com	Dhaka District	Ramna	1	250	730	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-26 15:44:04.656	2026-10-26 15:44:04.656	\N	\N	0	\N	f	ONLINE
b47fe4f6-54b1-43c1-9d7d-61029ac82cbb	\N	\N	7454880	shamim	01732256642	Thomas Tower, Flat-2 A 			Dhaka District	Shiddheswari	4	1130	3995	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-26 18:52:29.518	2026-10-26 18:52:29.518	\N	\N	0	\N	f	ONLINE
d76627f1-0b36-4e3a-9cda-7ff12f4a36cc	\N	\N	8226281	Shamim Rahman	01748399860	kakrail		shamimrocky801@yahoo.com	Dhaka District	Ramna	5	3620	7130	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-26 19:44:02.266	2026-10-26 19:44:02.266	\N	\N	0	\N	f	ONLINE
b5dfa66b-6d3f-4279-9e0b-3c1a9a68855b	\N	\N	0928670	Md. Shamim Rahman	01748399860	Kakrail			Dhaka District	Shiddheswari	2	1110	2600	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-28 15:41:48.258	2026-10-28 15:41:48.258	\N	\N	0	\N	f	ONLINE
f24c54d2-5189-4217-aff6-2ea9ee7d966d	\N	\N	2947331	Md. Shamim Rahman	01748399860	Kakrail			Dhaka District	Shiddheswari	1	720	1880	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-28 19:21:36.511	2026-10-28 19:21:36.511	\N	\N	0	\N	f	ONLINE
b8194917-0b4a-4f2c-ba7d-dd90e6298c7e	\N	\N	7798681	Shamim Rahman	01748399860	kakrail		shamimrocky801@yahoo.com	Dhaka District	Ramna	1	510	1268	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-29 16:03:03.776	2026-10-29 16:03:03.776	\N	\N	0	\N	f	ONLINE
3c7adc6e-ad2b-4841-8888-3dc9f1cf8dd2	\N	\N	3784320	Shamim Rahman	01748399860	kakrail		shamimrocky801@yahoo.com	Dhaka District	Ramna	4	2040	4715	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-11-01 17:49:50.595	2026-11-01 17:49:50.595	\N	\N	0	\N	f	ONLINE
ee7134ea-167e-4aa8-abc1-3fe04bd50a85	\N	\N	5081561	Shamim Rahman	01748399860	test		shamimrocky801@yahoo.com	Dhaka District	Ramna	1	320	880	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-11-01 17:51:51.31	2026-11-01 17:51:51.31	\N	\N	0	\N	f	ONLINE
518584fa-517b-4f6c-bc89-3bddb63054fa	\N	\N	5525481	shamim	01732256642	Thomas Tower, Flat-2 A 			Dhaka District	Shiddheswari	13	390	5373	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-11-04 09:12:38.875	2026-11-04 09:12:38.875	\N	\N	0	\N	f	ONLINE
de5aa7d4-a42c-4175-87fe-e6eba7aaa77e	\N	\N	8306701	shamim	01732256642	Thomas Tower, Flat-2 A 			Dhaka District	Shiddheswari	14	1160	13284	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-11-04 09:17:14.627	2026-11-04 09:17:14.627	\N	\N	0	\N	f	ONLINE
df698dbc-4795-4d7d-a10e-f340258506c0	\N	\N	7378880	Shamim Rahman	01748399860	test		shamimrocky801@yahoo.com	Dhaka District	Ramna	4	2300	5550	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-25 20:39:18.082	2026-10-25 20:39:18.082	\N	\N	0	\N	f	ONLINE
48ac8c2a-4c07-4dbf-9d9e-4905df9beaa4	\N	\N	8354600	Shamim Rahman	01748399860	kakrail		shamimrocky801@yahoo.com	Dhaka District	Ramna	2	1210	3071	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-25 20:40:43.502	2026-10-25 20:40:43.502	\N	\N	0	\N	f	ONLINE
9bd242e9-da91-45c3-ac3a-39bb59cbc154	\N	\N	8645361	Shamim Rahman	01748399860	kakrail		shamimrocky801@yahoo.com	Dhaka District	Ramna	1	720	1880	Cash on Delivery	PENDING	\N	80	\N	f	\N	\N	2026-10-25 20:41:11.529	2026-10-25 20:41:11.529	\N	\N	0	\N	f	ONLINE
\.


--
-- Data for Name: OrderItem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."OrderItem" (id, "orderId", "productId", "productAttributeId", name, size, "costPrice", "retailPrice", "discountPercent", "discountPrice", "discountedRetailPrice", quantity, "totalCostPrice", "totalPrice", "isDeleted", "createdBy", "updatedBy", "createdAt", "updatedAt") FROM stdin;
e217acb9-40fc-4726-8a6f-0ba47d565b99	46a47c1a-255f-4d9f-a94e-70d0dca0a51b	9c4dfc17-0be9-4abd-ba0f-0dfd49aeb0cf	4648a028-8f27-488d-8503-f3708b3d8848	Men's Formal Shirt Light Blue	Size: S	1500	1950	0	0	1950	1	1500	1950	f	\N	\N	2026-10-24 09:30:01.748	2026-10-24 09:30:01.748
6ab156c0-36db-4dce-9a8a-9c3b7ed48be1	89daffdd-a659-4591-8f21-3cf87249a260	9c4dfc17-0be9-4abd-ba0f-0dfd49aeb0cf	4648a028-8f27-488d-8503-f3708b3d8848	Men's Formal Shirt Light Blue	Size: S	1500	1950	10	195	1755	6	9000	10530	f	\N	\N	2026-10-24 18:15:31.539	2026-10-24 18:15:31.539
4013b9b3-ff24-446d-ae7a-905cfbe1f701	e1acc2da-17f9-45f5-9285-5a0dca3aa086	9c4dfc17-0be9-4abd-ba0f-0dfd49aeb0cf	938f8213-0f92-46bb-b436-c5090f64bcfe	Men's Formal Shirt Light Blue	Size: XL	1500	1950	10	195	1755	1	1500	1755	f	\N	\N	2026-10-24 18:17:19.696	2026-10-24 18:17:19.696
ccd112e4-1c10-46ce-92e4-fec48134cb7d	567259ba-aaf3-49ac-9922-dc07665bea50	9c4dfc17-0be9-4abd-ba0f-0dfd49aeb0cf	26598848-bb01-4c7e-be36-00faa0895a8f	Men's Formal Shirt Light Blue	Size: L	1500	1950	10	195	1755	1	1500	1755	f	\N	\N	2026-10-24 20:23:16.369	2026-10-24 20:23:16.369
a10645b0-156b-4bf7-94ed-5175848989f0	567259ba-aaf3-49ac-9922-dc07665bea50	1a4f4714-447c-449d-b68f-4a339d535f5c	2b0d0b4f-16bc-4ffa-bc0d-4455fe9f45a6	Men Striped Casual Polo	XL	390	950	10	95	855	1	390	855	f	\N	\N	2026-10-24 20:23:16.369	2026-10-24 20:23:16.369
2f94e1be-da8c-4fe4-b69a-84252c039f04	b359ea0c-916c-45d2-a57d-4b3dbf5f5fd0	c530f1c8-97d7-4573-8ecf-62c63593a252	b410ca9f-e127-414f-b5d6-90c46a29ae8f	Men Formal Office Shirt (Solid)	XL	510	1320	10	132	1188	1	510	1188	f	\N	\N	2026-10-25 19:49:45.515	2026-10-25 19:49:45.515
50add19f-4472-446b-ace2-5dda3d0d770c	594268d3-f162-4e92-8b3b-8ba16ac4deed	1a4f4714-447c-449d-b68f-4a339d535f5c	2b0d0b4f-16bc-4ffa-bc0d-4455fe9f45a6	Men Striped Casual Polo	XL	390	950	10	95	855	1	390	855	f	\N	\N	2026-10-25 19:53:59.445	2026-10-25 19:53:59.445
83d869ee-c456-4056-aa9c-dd12f5da4dd1	594268d3-f162-4e92-8b3b-8ba16ac4deed	fb08a2dc-2287-4702-b88c-4a60ccea278c	90b2efa1-086d-4ffc-9576-08d9ce541a97	Men Chino Casual Trouser	L	650	1600	10	160	1440	1	650	1440	f	\N	\N	2026-10-25 19:53:59.445	2026-10-25 19:53:59.445
8be149e6-8f86-4c47-b81e-f66e9c3070de	594268d3-f162-4e92-8b3b-8ba16ac4deed	f879d781-a80d-49db-a89f-5696b0cb9e8b	778cea45-f760-4762-bbdb-659fde290077	Men Business Slim Fit Shirt	XL	500	1300	10	130	1170	1	500	1170	f	\N	\N	2026-10-25 19:53:59.445	2026-10-25 19:53:59.445
7eb224bd-0100-4022-980a-4697047d5881	362d02fb-4ed7-4972-8cc5-8e3fe904705d	1a4f4714-447c-449d-b68f-4a339d535f5c	f3e3067d-4fd1-40d1-b6cb-a1f505d9eddf	Men Striped Casual Polo	L	390	950	10	95	855	1	390	855	f	\N	\N	2026-10-25 19:55:30.829	2026-10-25 19:55:30.829
0b2a47f7-c97e-4db0-ad41-54953ec63b52	362d02fb-4ed7-4972-8cc5-8e3fe904705d	a79405f9-9b42-4c8e-8d97-6e6b28a7be3a	d69edb49-e801-411e-be05-b6a71fcd8dec	Men Classic Cotton Polo Shirt	M	380	920	10	92	828	1	380	828	f	\N	\N	2026-10-25 19:55:30.829	2026-10-25 19:55:30.829
7eb7cba6-469a-41e0-85b4-2eee0eea8436	df698dbc-4795-4d7d-a10e-f340258506c0	ef7e970f-a415-45f4-b98b-0aa741925ea3	3c86eeec-7656-47a9-be24-c84385d22b2d	Men Genuine Leather Formal Shoes	40	950	2300	0	0	2300	1	950	2300	f	\N	\N	2026-10-25 20:39:18.082	2026-10-25 20:39:18.082
c4fa97bd-03d3-4ef4-b81f-ede2dbec89d9	df698dbc-4795-4d7d-a10e-f340258506c0	ae7c9c8d-086a-4e84-a419-33871d80d88f	f229e8cc-118e-4521-97fa-6e9df52a64cd	Executive Formal Office Shirt	L	500	1300	10	130	1170	1	500	1170	f	\N	\N	2026-10-25 20:39:18.082	2026-10-25 20:39:18.082
08a53675-a8b2-4112-b0ee-6e161c4308c9	df698dbc-4795-4d7d-a10e-f340258506c0	0ceab60b-154c-4f0a-b16f-4d8e6628b1e5	3f4730e6-4af1-4457-8e37-ff66d566b681	Classic Formal Trouser	30	600	1500	10	150	1350	1	600	1350	f	\N	\N	2026-10-25 20:39:18.082	2026-10-25 20:39:18.082
69e19bf0-4095-4bd5-9921-1d28b96cc9f1	df698dbc-4795-4d7d-a10e-f340258506c0	9d7c598a-dbdb-4ab2-bf06-277e66287d68	8cf78a75-6ecf-4869-ab0a-078277265dcf	Genuine Leather Formal Belt	38	250	650	0	0	650	1	250	650	f	\N	\N	2026-10-25 20:39:18.082	2026-10-25 20:39:18.082
c98132b0-3cd6-4e94-a1ab-8badbd614452	48ac8c2a-4c07-4dbf-9d9e-4905df9beaa4	3657f403-d21f-414d-8fe0-c8535b8ebdca	ec2c1062-f41c-467b-9acd-e5b25b3c4cf2	Men Premium Collar Polo	L	410	990	10	99	891	1	410	891	f	\N	\N	2026-10-25 20:40:43.502	2026-10-25 20:40:43.502
3e170a6c-12b3-46e8-871a-be944eda441a	48ac8c2a-4c07-4dbf-9d9e-4905df9beaa4	2099a22c-4955-44c4-af6b-6616e133247e	eb34a16b-045f-4548-84a9-e4b3374f51a6	Women New IN Elegant Gown	XL	800	2100	0	0	2100	1	800	2100	f	\N	\N	2026-10-25 20:40:43.502	2026-10-25 20:40:43.502
6226a244-8ed5-49bc-9618-95f2d5217001	9bd242e9-da91-45c3-ac3a-39bb59cbc154	b15ba6e3-7ad4-437a-8f23-5db2ce4c7f3e	4c49f554-2812-4add-9851-ea97cb3185d7	Women New IN Floral Party Dress	L	720	1800	0	0	1800	1	720	1800	f	\N	\N	2026-10-25 20:41:11.529	2026-10-25 20:41:11.529
1cca9ec2-0e3c-4067-85e7-5db738295c28	d2e9f146-4536-4a5b-b4b3-bbabf02b92f4	38069b07-6fd4-4a53-9d7c-ff6e52ebfdec	8b8eae1b-0863-469c-acdb-61873e0ebd95	Men Leather Brogue Formal Shoes	38	1000	2500	0	0	2500	1	1000	2500	f	\N	\N	2026-10-26 07:11:59.313	2026-10-26 07:11:59.313
8aa33e24-455b-43be-9055-7da2ed5f704b	caff7545-fec0-45b4-a840-286f7841a85c	9d7c598a-dbdb-4ab2-bf06-277e66287d68	5c369a50-8202-4da7-9c91-1f06e804dca2	Genuine Leather Formal Belt	34	250	650	0	0	650	1	250	650	f	\N	\N	2026-10-26 15:44:04.656	2026-10-26 15:44:04.656
3eb99478-7073-4919-9785-7a627b8a1dcd	b47fe4f6-54b1-43c1-9d7d-61029ac82cbb	fb08a2dc-2287-4702-b88c-4a60ccea278c	aa21a523-c202-44e5-91cf-415469d36a33	Men Chino Casual Trouser	M	650	1600	10	160	1440	1	650	1440	f	\N	\N	2026-10-26 18:52:29.518	2026-10-26 18:52:29.518
f1cc545a-9e80-4240-b32a-dfdc8ce291d7	b47fe4f6-54b1-43c1-9d7d-61029ac82cbb	a79405f9-9b42-4c8e-8d97-6e6b28a7be3a	1b9c18da-84e6-47c4-b10a-dbfc73bd150a	Men Classic Cotton Polo Shirt	L	380	920	10	92	828	1	380	828	f	\N	\N	2026-10-26 18:52:29.518	2026-10-26 18:52:29.518
de8d5f77-433f-4a2f-87fd-e50f9535e14c	b47fe4f6-54b1-43c1-9d7d-61029ac82cbb	1a4f4714-447c-449d-b68f-4a339d535f5c	29660394-f905-45d5-ba5b-e89421e201af	Men Striped Casual Polo	M	390	950	10	95	855	1	390	855	f	\N	\N	2026-10-26 18:52:29.518	2026-10-26 18:52:29.518
794c4403-6a3e-45a4-9e23-b0b06b25f2fe	b47fe4f6-54b1-43c1-9d7d-61029ac82cbb	247c17ed-3853-462e-b4a2-1c4f4fbfce35	f0c7d7e0-864a-483d-8b2a-dac03bd842cc	Men Sports Dry-Fit Polo Shirt	M	360	880	10	88	792	1	360	792	f	\N	\N	2026-10-26 18:52:29.518	2026-10-26 18:52:29.518
d75ad48d-d602-4c9c-ac1a-a6507d2982bf	d76627f1-0b36-4e3a-9cda-7ff12f4a36cc	bfa9b3b5-38cb-4d63-8501-694125f75f63	cfe9ee14-f468-4e94-b6cd-f5f185031ed6	Men Gabardine Formal Trouser	M	620	1550	10	155	1395	1	620	1395	f	\N	\N	2026-10-26 19:44:02.266	2026-10-26 19:44:02.266
0e3972fa-1025-40e1-b47b-d9c18fb02205	d76627f1-0b36-4e3a-9cda-7ff12f4a36cc	9d7c598a-dbdb-4ab2-bf06-277e66287d68	5c369a50-8202-4da7-9c91-1f06e804dca2	Genuine Leather Formal Belt	34	250	650	0	0	650	1	250	650	f	\N	\N	2026-10-26 19:44:02.266	2026-10-26 19:44:02.266
8e969906-896c-49e3-8ca7-69fbb05f4224	d76627f1-0b36-4e3a-9cda-7ff12f4a36cc	9db7bb7f-bbcf-47c6-82e6-c83640206bc6	1229d932-9dbe-4757-b42f-e879a970f34b	UV Protection Fashion Sunglass	Free	300	850	0	0	850	1	300	850	f	\N	\N	2026-10-26 19:44:02.266	2026-10-26 19:44:02.266
daaddad2-e20a-414e-8902-2d54f32a7cd2	d76627f1-0b36-4e3a-9cda-7ff12f4a36cc	4ed57174-1e05-4c61-b41f-2b3ea9c04474	02e8e362-128b-4b7e-a3cf-f50e0d7ee2e6	Men Formal Oxford Shoes	37	950	2400	0	0	2400	1	950	2400	f	\N	\N	2026-10-26 19:44:02.266	2026-10-26 19:44:02.266
da7b79f5-e6e9-4bc0-9ced-8ae7635cdcbc	d76627f1-0b36-4e3a-9cda-7ff12f4a36cc	9c4dfc17-0be9-4abd-ba0f-0dfd49aeb0cf	938f8213-0f92-46bb-b436-c5090f64bcfe	Men's Formal Shirt Light Blue	Size: XL	1500	1950	10	195	1755	1	1500	1755	f	\N	\N	2026-10-26 19:44:02.266	2026-10-26 19:44:02.266
7a588276-cb2e-463b-8bee-a87d28547464	b5dfa66b-6d3f-4279-9e0b-3c1a9a68855b	1a4f4714-447c-449d-b68f-4a339d535f5c	f3e3067d-4fd1-40d1-b6cb-a1f505d9eddf	Men Striped Casual Polo	L	390	950	10	95	855	1	390	855	f	\N	\N	2026-10-28 15:41:48.258	2026-10-28 15:41:48.258
3cdb7a6d-9f49-43af-87cf-746a336e5ebd	b5dfa66b-6d3f-4279-9e0b-3c1a9a68855b	570a2ef9-68b3-48a1-9eec-e0a1b7613714	8bbbe703-bd29-47ee-9f58-3f07c7bd844c	Men Slim Fit Black Jeans	M	720	1850	10	185	1665	1	720	1665	f	\N	\N	2026-10-28 15:41:48.258	2026-10-28 15:41:48.258
b4c6ede5-b0d0-4910-aa9c-65f344eb81db	f24c54d2-5189-4217-aff6-2ea9ee7d966d	b15ba6e3-7ad4-437a-8f23-5db2ce4c7f3e	4c49f554-2812-4add-9851-ea97cb3185d7	Women New IN Floral Party Dress	L	720	1800	0	0	1800	1	720	1800	f	\N	\N	2026-10-28 19:21:36.511	2026-10-28 19:21:36.511
5ea25017-cf72-416e-a569-31e1b7d5c0ed	b8194917-0b4a-4f2c-ba7d-dd90e6298c7e	c530f1c8-97d7-4573-8ecf-62c63593a252	b6f61d2e-0f9f-43b0-b598-e12b7cb7b8c3	Men Formal Office Shirt (Solid)	M	510	1320	10	132	1188	1	510	1188	f	\N	\N	2026-10-29 16:03:03.776	2026-10-29 16:03:03.776
9f3db9ae-61eb-4556-9091-65fe8e6ee6e1	3c7adc6e-ad2b-4841-8888-3dc9f1cf8dd2	c530f1c8-97d7-4573-8ecf-62c63593a252	98937cb3-588a-4f71-bef6-90cbdf14d86e	Men Formal Office Shirt (Solid)	L	510	1320	10	132	1188	1	510	1188	f	\N	\N	2026-11-01 17:49:50.595	2026-11-01 17:49:50.595
a45883c9-c8a8-4dba-890f-32bc16c4d721	3c7adc6e-ad2b-4841-8888-3dc9f1cf8dd2	3657f403-d21f-414d-8fe0-c8535b8ebdca	ec2c1062-f41c-467b-9acd-e5b25b3c4cf2	Men Premium Collar Polo	L	410	990	10	99	891	1	410	891	f	\N	\N	2026-11-01 17:49:50.595	2026-11-01 17:49:50.595
55e7eda4-ae0f-4d3a-bf66-36f65a02cd97	3c7adc6e-ad2b-4841-8888-3dc9f1cf8dd2	570a2ef9-68b3-48a1-9eec-e0a1b7613714	e0ecc281-be44-4653-94e4-d2936e1712b7	Men Slim Fit Black Jeans	L	720	1850	10	185	1665	1	720	1665	f	\N	\N	2026-11-01 17:49:50.595	2026-11-01 17:49:50.595
1fee3835-a05f-40fb-915c-959bd4338410	3c7adc6e-ad2b-4841-8888-3dc9f1cf8dd2	f3bb6102-568b-4ca1-b0e5-e4288083c0a9	4d861a6e-0bea-43d0-a2cc-7a24be4d694c	Men Casual Half Sleeve Check Shirt	L	400	990	10	99	891	1	400	891	f	\N	\N	2026-11-01 17:49:50.595	2026-11-01 17:49:50.595
79705099-c08e-44f4-8fe9-e8ae27de8429	ee7134ea-167e-4aa8-abc1-3fe04bd50a85	236dc197-0259-43c5-a617-211965cb79d3	29a7d60a-0a29-46b3-9d02-2097d0e78c96	Bangladesh National Cricket Jersey	M	320	800	0	0	800	1	320	800	f	\N	\N	2026-11-01 17:51:51.31	2026-11-01 17:51:51.31
235ed547-270a-498d-8818-fe79dda19401	518584fa-517b-4f6c-bc89-3bddb63054fa	1a4f4714-447c-449d-b68f-4a339d535f5c	61997b81-81db-4a50-987e-c24e9504c080	Men Striped Casual Polo	XXL	390	950	10	95	855	3	1170	2565	f	\N	\N	2026-11-04 09:12:38.875	2026-11-04 09:12:38.875
eee720cf-630e-4dd2-8ec8-8701d5bf9c9e	518584fa-517b-4f6c-bc89-3bddb63054fa	62c78000-e142-448a-a870-3e74bc7fabfa	cf8423aa-5deb-485a-a298-5fad764f0c7e	Men Heavy Duty Stretch Denim Jeans	XL	750	1900	10	190	1710	5	3750	8550	f	\N	\N	2026-11-04 09:12:38.875	2026-11-04 09:12:38.875
cc9d1ad7-a009-4aa0-b624-ea5001127982	518584fa-517b-4f6c-bc89-3bddb63054fa	fcd96dd4-e631-46bd-b5e8-ff564ce5dea7	abad65b6-e6d5-426f-85fc-8ebf18553f15	Women New IN Western Party Outfit	M	750	1900	0	0	1900	1	750	1900	f	\N	\N	2026-11-04 09:12:38.875	2026-11-04 09:12:38.875
3f437b19-0322-4ece-ae51-a99d2880be56	518584fa-517b-4f6c-bc89-3bddb63054fa	a79405f9-9b42-4c8e-8d97-6e6b28a7be3a	df730f76-5d2b-4a47-8588-673bd3c5f650	Men Classic Cotton Polo Shirt	XL	380	920	10	92	828	4	1520	3312	f	\N	\N	2026-11-04 09:12:38.875	2026-11-04 09:12:38.875
7459192c-797b-4449-8ed7-5ca469af3008	de5aa7d4-a42c-4175-87fe-e6eba7aaa77e	3657f403-d21f-414d-8fe0-c8535b8ebdca	17d15409-3f51-465f-aab0-5b4af77336e3	Men Premium Collar Polo	XL	410	990	10	99	891	2	820	1782	f	\N	\N	2026-11-04 09:17:14.627	2026-11-04 09:17:14.627
896c48ed-f50e-493e-915d-175a5f9f4b23	de5aa7d4-a42c-4175-87fe-e6eba7aaa77e	fcd96dd4-e631-46bd-b5e8-ff564ce5dea7	abad65b6-e6d5-426f-85fc-8ebf18553f15	Women New IN Western Party Outfit	M	750	1900	0	0	1900	2	1500	3800	f	\N	\N	2026-11-04 09:17:14.627	2026-11-04 09:17:14.627
3269d184-a384-49b8-8f7c-698a2def4869	de5aa7d4-a42c-4175-87fe-e6eba7aaa77e	fb08a2dc-2287-4702-b88c-4a60ccea278c	599dda06-a39b-4b52-9726-896890f14880	Men Chino Casual Trouser	XXL	650	1600	10	160	1440	1	650	1440	f	\N	\N	2026-11-04 09:17:14.627	2026-11-04 09:17:14.627
759a6328-4c58-469d-a746-bae2e33bd469	de5aa7d4-a42c-4175-87fe-e6eba7aaa77e	62c78000-e142-448a-a870-3e74bc7fabfa	cf8423aa-5deb-485a-a298-5fad764f0c7e	Men Heavy Duty Stretch Denim Jeans	XL	750	1900	10	190	1710	1	750	1710	f	\N	\N	2026-11-04 09:17:14.627	2026-11-04 09:17:14.627
1a3e9756-53cb-4115-b3ae-9710e6c26dfb	de5aa7d4-a42c-4175-87fe-e6eba7aaa77e	a79405f9-9b42-4c8e-8d97-6e6b28a7be3a	df730f76-5d2b-4a47-8588-673bd3c5f650	Men Classic Cotton Polo Shirt	XL	380	920	10	92	828	2	760	1656	f	\N	\N	2026-11-04 09:17:14.627	2026-11-04 09:17:14.627
3a34d2f8-4879-49de-add9-6a41349170ec	de5aa7d4-a42c-4175-87fe-e6eba7aaa77e	c530f1c8-97d7-4573-8ecf-62c63593a252	98937cb3-588a-4f71-bef6-90cbdf14d86e	Men Formal Office Shirt (Solid)	L	510	1320	10	132	1188	1	510	1188	f	\N	\N	2026-11-04 09:17:14.627	2026-11-04 09:17:14.627
822808f4-18c3-4480-bfbc-035b08e3b49c	de5aa7d4-a42c-4175-87fe-e6eba7aaa77e	1a4f4714-447c-449d-b68f-4a339d535f5c	61997b81-81db-4a50-987e-c24e9504c080	Men Striped Casual Polo	XXL	390	950	10	95	855	1	390	855	f	\N	\N	2026-11-04 09:17:14.627	2026-11-04 09:17:14.627
c6a71154-c1c7-4c72-a15c-949f136dd992	de5aa7d4-a42c-4175-87fe-e6eba7aaa77e	247c17ed-3853-462e-b4a2-1c4f4fbfce35	1016448f-3831-46ae-9ae0-37c69a281cad	Men Sports Dry-Fit Polo Shirt	L	360	880	10	88	792	1	360	792	f	\N	\N	2026-11-04 09:17:14.627	2026-11-04 09:17:14.627
484d003f-bbb9-40cd-8a61-47530db8f915	de5aa7d4-a42c-4175-87fe-e6eba7aaa77e	01202189-9e12-43b5-b326-d2324501ed7e	3e700e92-fe07-4a5e-a4d4-1d0cd326dca3	Men Premium Oxford Full Sleeve Shirt	L	480	1200	10	120	1080	1	480	1080	f	\N	\N	2026-11-04 09:17:14.627	2026-11-04 09:17:14.627
5c7832e4-f896-4cec-a34f-f301291d52cc	de5aa7d4-a42c-4175-87fe-e6eba7aaa77e	f879d781-a80d-49db-a89f-5696b0cb9e8b	de488e00-792d-4a07-81b2-daeed8d2e5ba	Men Business Slim Fit Shirt	L	500	1300	10	130	1170	1	500	1170	f	\N	\N	2026-11-04 09:17:14.627	2026-11-04 09:17:14.627
0a4a4e8d-3175-4413-a76e-d7c39d88fdfe	de5aa7d4-a42c-4175-87fe-e6eba7aaa77e	8aa29284-2997-4130-bc55-a213eb620567	34b2aeb3-0829-48d5-94b4-b5cf7fa15b8c	Women Designer Party Wear Kurti	M	520	1350	0	0	1350	1	520	1350	f	\N	\N	2026-11-04 09:17:14.627	2026-11-04 09:17:14.627
\.


--
-- Data for Name: Payment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Payment" (id, "userId", date, amount, due, "isDeleted", "createdBy", "updatedBy", "deletedBy", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Preorder; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Preorder" (id, "productId", "userId", "createdAt", "updatedAt", "productAttributeId") FROM stdin;
\.


--
-- Data for Name: Product; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Product" (id, "userId", "categoryId", "subcategoryId", "subsubcategoryId", "campaignId", "supplierId", "brandId", "productCode", barcode, name, "shortDescription", "longDescription", sku, "isTrending", "isFeatured", "viewCount", slug, "createdBy", "updatedBy", "deletedBy", "isActive", "isDeleted", "createdAt", "updatedAt", "masterProductId", "sizeChartId") FROM stdin;
9c4dfc17-0be9-4abd-ba0f-0dfd49aeb0cf	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	162123b5-cd08-4c06-b00b-9bcad9b6bbc7	bbe56d99-e69f-4cc2-9954-77c1bd9f7236	\N	\N	\N	test	Bangladesh	Men's Formal Shirt Light Blue	Elegant long-sleeve formal shirt with subtle textured weave and regular fit tailoring.\r\n\r\n	Elegant long-sleeve formal shirt with subtle textured weave and regular fit tailoring.\r\n\r\nDesigned for sharp, professional stylingmen's shirt features a fine textured pattern for a refined look. Made from premium lightweight fabric, it offers a crisp appearance with excellent breathability. The slim-fit silhouette enhances the body shape while allowing ease of movement. It includes a classic spread collar, full button placket, and barrel cuffs perfect for office wear, formal meetings, or evening events.\r\n\r\nFabric: BLENDED FABRIC\r\n\r\nCare Label:\r\n\r\nBLENDED FABRICS\r\nWASH UP TO 30C\r\nDO NOT BLEACH\r\nDO NOT TUMBLE DRY\r\nIRON AT110 C\r\nDO NOT DRY CLEAN\r\nWASH INSIDE OUT\r\nAND DRY SEPARATELY	test	t	t	0	clothingbrandstrike-mens-formal-shirt-light-blue	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 09:27:38.324	2026-10-24 09:27:38.324	\N	\N
6e3a75fe-be49-4e90-ba55-452458ca8db2	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	162123b5-cd08-4c06-b00b-9bcad9b6bbc7	04cac189-f852-4068-852b-61dbc8f8fcfc	\N	\N	\N	\N	\N	Oxford Full Sleeve Shirt	Premium cotton full sleeve shirt.	\N	SHIRT-FS-001	t	t	0	clothingbrandstrike-oxford-full-sleeve-shirt-1792871725041	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:55:25.041	2026-10-24 19:55:25.041	\N	\N
c90772e3-8704-4479-bcf0-ddb20fb726be	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	162123b5-cd08-4c06-b00b-9bcad9b6bbc7	f655b6bb-79eb-48c8-af1d-85f03a7d7986	\N	\N	\N	\N	\N	Slim Fit Half Shirt	Stylish half sleeve casual shirt.	\N	SHIRT-HS-002	t	f	0	clothingbrandstrike-slim-fit-half-shirt-1792871725052	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:55:25.052	2026-10-24 19:55:25.052	\N	\N
ae7c9c8d-086a-4e84-a419-33871d80d88f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	162123b5-cd08-4c06-b00b-9bcad9b6bbc7	bbe56d99-e69f-4cc2-9954-77c1bd9f7236	\N	\N	\N	\N	\N	Executive Formal Office Shirt	Professional formal shirt for office.	\N	SHIRT-FM-003	f	t	0	clothingbrandstrike-executive-formal-office-shirt-1792871725061	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:55:25.061	2026-10-24 19:55:25.061	\N	\N
dab94f06-0e68-44c8-b458-c00011013d51	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	162123b5-cd08-4c06-b00b-9bcad9b6bbc7	732f5a4b-c6bc-4160-a007-3d156dd9ecc1	\N	\N	\N	\N	\N	Modern Check Casual Shirt	Modern checkered pattern casual shirt.	\N	SHIRT-CS-004	t	t	0	clothingbrandstrike-modern-check-casual-shirt-1792871725070	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:55:25.07	2026-10-24 19:55:25.07	\N	\N
0ceab60b-154c-4f0a-b16f-4d8e6628b1e5	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	b669cc73-17ee-4e6d-adba-d1614f262971	91761453-1ae4-4a43-927d-0e50d9f6f015	\N	\N	\N	\N	\N	Classic Formal Trouser	Comfortable formal trousers for men.	\N	PANT-FP-005	f	f	0	clothingbrandstrike-classic-formal-trouser-1792871725079	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:55:25.079	2026-10-24 19:55:25.079	\N	\N
4e8ad248-7b05-42bf-9974-95ded09be7b3	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	b669cc73-17ee-4e6d-adba-d1614f262971	2d4d060e-4642-4fb3-93f5-abd655475485	\N	\N	\N	\N	\N	Stretch Denim Jeans Pant	Flexible denim jeans for daily wear.	\N	PANT-DN-006	t	t	0	clothingbrandstrike-stretch-denim-jeans-pant-1792871725088	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:55:25.088	2026-10-24 19:55:25.088	\N	\N
8eb6e435-c1fc-4206-ba03-6f1a6f359eac	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	39a623bc-9948-45c9-935d-7f104dd61593	76995099-694a-42d7-a106-ef73cd5ba09c	a665f7cb-5547-40c4-964f-e9e753fc0a08	\N	\N	\N	\N	\N	Real Madrid Home Club Jersey	Fan edition club football jersey.	\N	JERSY-CL-007	t	t	0	clothingbrandstrike-real-madrid-home-club-jersey-1792871581475	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	t	t	2026-10-24 19:53:01.476	2026-10-25 19:41:17.55	\N	\N
e71f9fad-272e-4aab-965f-a394e68380be	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	b669cc73-17ee-4e6d-adba-d1614f262971	2d4d060e-4642-4fb3-93f5-abd655475485	\N	\N	\N	\N	\N	Stretch Denim Jeans Pant	Flexible denim jeans for daily wear.	\N	PANT-DN-006	t	t	0	clothingbrandstrike-stretch-denim-jeans-pant-1792871581465	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	t	t	2026-10-24 19:53:01.465	2026-10-25 19:41:26.68	\N	\N
a2146adb-df43-4993-9013-34aba09c624a	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	162123b5-cd08-4c06-b00b-9bcad9b6bbc7	04cac189-f852-4068-852b-61dbc8f8fcfc	\N	\N	\N	\N	\N	Oxford Full Sleeve Shirt	Premium cotton full sleeve shirt.	\N	SHIRT-FS-001	t	t	0	clothingbrandstrike-oxford-full-sleeve-shirt-1792871581310	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	t	t	2026-10-24 19:53:01.31	2026-10-25 19:41:40.121	\N	\N
60bd6453-f492-4aab-bf27-15a4b41b4a62	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	162123b5-cd08-4c06-b00b-9bcad9b6bbc7	f655b6bb-79eb-48c8-af1d-85f03a7d7986	\N	\N	\N	\N	\N	Slim Fit Half Shirt	Stylish half sleeve casual shirt.	\N	SHIRT-HS-002	t	f	0	clothingbrandstrike-slim-fit-half-shirt-1792871581351	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	t	t	2026-10-24 19:53:01.351	2026-10-25 19:41:44.702	\N	\N
9db63b45-9a3c-4f48-8426-0b77c5de7eb7	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	162123b5-cd08-4c06-b00b-9bcad9b6bbc7	bbe56d99-e69f-4cc2-9954-77c1bd9f7236	\N	\N	\N	\N	\N	Executive Formal Office Shirt	Professional formal shirt for office.	\N	SHIRT-FM-003	f	t	0	clothingbrandstrike-executive-formal-office-shirt-1792871581367	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	t	t	2026-10-24 19:53:01.368	2026-10-25 19:41:48.558	\N	\N
719f5b65-c98e-453d-bcc7-ac8ee78a442f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	162123b5-cd08-4c06-b00b-9bcad9b6bbc7	732f5a4b-c6bc-4160-a007-3d156dd9ecc1	\N	\N	\N	\N	\N	Modern Check Casual Shirt	Modern checkered pattern casual shirt.	\N	SHIRT-CS-004	t	t	0	clothingbrandstrike-modern-check-casual-shirt-1792871581379	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	t	t	2026-10-24 19:53:01.379	2026-10-25 19:41:54.302	\N	\N
e4364168-964f-43b9-b2ec-3bfba2477e85	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	b669cc73-17ee-4e6d-adba-d1614f262971	91761453-1ae4-4a43-927d-0e50d9f6f015	\N	\N	\N	\N	\N	Classic Formal Trouser	Comfortable formal trousers for men.	\N	PANT-FP-005	f	f	0	clothingbrandstrike-classic-formal-trouser-1792871581390	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	t	t	2026-10-24 19:53:01.39	2026-10-25 19:41:57.821	\N	\N
ecbc1023-f440-4569-8772-0409b82150ae	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	39a623bc-9948-45c9-935d-7f104dd61593	76995099-694a-42d7-a106-ef73cd5ba09c	a665f7cb-5547-40c4-964f-e9e753fc0a08	\N	\N	\N	\N	\N	Real Madrid Home Club Jersey	Fan edition club football jersey.	\N	JERSY-CL-007	t	t	0	clothingbrandstrike-real-madrid-home-club-jersey-1792871725098	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:55:25.098	2026-10-24 19:55:25.098	\N	\N
9b728cfe-d1d2-44ea-bec4-379216652a51	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	39a623bc-9948-45c9-935d-7f104dd61593	76995099-694a-42d7-a106-ef73cd5ba09c	3b249463-1907-4598-82dc-819b1f83e018	\N	\N	\N	\N	\N	Argentina World Cup Jersey	Official style international jersey.	\N	JERSY-INT-008	t	t	0	clothingbrandstrike-argentina-world-cup-jersey-1792871725106	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:55:25.107	2026-10-24 19:55:25.107	\N	\N
e89d6f03-391c-48c3-84ce-02e1e28a6ec6	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	162123b5-cd08-4c06-b00b-9bcad9b6bbc7	\N	\N	\N	\N	\N	\N	Men Oxford Full Sleeve Shirt	Premium cotton full sleeve shirt for men.	\N	SHIRT-FS-001	t	t	0	clothingbrandstrike-men-oxford-full-sleeve-shirt-1792871906600	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.601	2026-10-24 19:58:26.601	\N	\N
e17bfcd9-17b0-4adb-be18-d7d8f1e8d7f1	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	162123b5-cd08-4c06-b00b-9bcad9b6bbc7	\N	\N	\N	\N	\N	\N	Men Casual Half Shirt	Stylish half sleeve casual shirt.	\N	SHIRT-HS-002	t	f	0	clothingbrandstrike-men-casual-half-shirt-1792871906639	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.639	2026-10-24 19:58:26.639	\N	\N
71d4df0b-e4a9-4c8a-aa54-317261858859	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	b09305fb-3470-4f62-a4a9-576813e3fb8d	88ae1a34-ea1c-4704-ae77-0b6a346955b6	\N	\N	\N	\N	\N	\N	Women Designer Kurti	Elegant traditional kurti for women.	\N	WOMEN-KURTI-003	t	t	0	clothingbrandstrike-women-designer-kurti-1792871906650	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.65	2026-10-24 19:58:26.65	\N	\N
9ea58a0c-9562-4d62-a59d-77ca5fe66741	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	b09305fb-3470-4f62-a4a9-576813e3fb8d	88ae1a34-ea1c-4704-ae77-0b6a346955b6	\N	\N	\N	\N	\N	\N	Women Casual Kurti	Comfortable daily wear kurti.	\N	WOMEN-KURTI-004	f	f	0	clothingbrandstrike-women-casual-kurti-1792871906659	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.659	2026-10-24 19:58:26.659	\N	\N
da2ae24e-1027-45b7-a7ba-6e0c4a66f678	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	b09305fb-3470-4f62-a4a9-576813e3fb8d	488ef54a-c290-474f-be0c-ce9ee125e7b1	\N	\N	\N	\N	\N	\N	Women New IN Party Dress	Latest collection party wear dress.	\N	WOMEN-NEW-005	t	t	0	clothingbrandstrike-women-new-in-party-dress-1792871906669	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.669	2026-10-24 19:58:26.669	\N	\N
43d3274b-0bc4-4c12-98ff-af2350f69402	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	b09305fb-3470-4f62-a4a9-576813e3fb8d	488ef54a-c290-474f-be0c-ce9ee125e7b1	\N	\N	\N	\N	\N	\N	Women New IN Trendy Outfit	New collection stylish western outfit.	\N	WOMEN-NEW-006	f	f	0	clothingbrandstrike-women-new-in-trendy-outfit-1792871906678	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.679	2026-10-24 19:58:26.679	\N	\N
d6d2ff2b-b9b3-4e46-9225-9ab39bae6071	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	b669cc73-17ee-4e6d-adba-d1614f262971	\N	\N	\N	\N	\N	\N	Men Formal Trouser	Professional formal pants for men.	\N	PANT-FORMAL-007	f	t	0	clothingbrandstrike-men-formal-trouser-1792871906687	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.687	2026-10-24 19:58:26.687	\N	\N
7626fb97-054a-4be1-ac2f-827fb07a479f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	b669cc73-17ee-4e6d-adba-d1614f262971	\N	\N	\N	\N	\N	\N	Men Stretch Denim Jeans	Flexible denim jeans pant.	\N	PANT-JEANS-008	t	t	0	clothingbrandstrike-men-stretch-denim-jeans-1792871906696	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.696	2026-10-24 19:58:26.696	\N	\N
2c968541-ab7c-42f5-b976-7383fad98ab8	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	553c3bb0-4e4d-4573-9f30-1eaaa11fdfe9	\N	\N	\N	\N	\N	\N	Men Classic Polo Shirt	Cotton rich solid polo shirt.	\N	POLO-009	t	f	0	clothingbrandstrike-men-classic-polo-shirt-1792871906706	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.706	2026-10-24 19:58:26.706	\N	\N
a7ec4f21-b399-40c5-8039-a020818df6c3	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	553c3bb0-4e4d-4573-9f30-1eaaa11fdfe9	\N	\N	\N	\N	\N	\N	Men Striped Polo Shirt	Casual striped polo t-shirt.	\N	POLO-010	f	f	0	clothingbrandstrike-men-striped-polo-shirt-1792871906715	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.715	2026-10-24 19:58:26.715	\N	\N
ef7e970f-a415-45f4-b98b-0aa741925ea3	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	204873a3-bdff-478c-bd70-8cd370df47f4	b562e88b-35c6-48e0-baf1-e810fd335869	\N	\N	\N	\N	\N	\N	Men Genuine Leather Formal Shoes	Classic leather shoes for office and formal events.	\N	SHOE-FORMAL-011	f	t	0	clothingbrandstrike-men-genuine-leather-formal-shoes-1792871906725	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.726	2026-10-24 19:58:26.726	\N	\N
1a0b08b6-6f05-4cbf-bbb8-004e256223cd	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	204873a3-bdff-478c-bd70-8cd370df47f4	041300cc-2e52-4aab-abdd-0472896fd3be	\N	\N	\N	\N	\N	\N	Sports Running Sneakers	Lightweight breathable sports sneakers.	\N	SHOE-SNEAK-012	t	t	0	clothingbrandstrike-sports-running-sneakers-1792871906735	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.735	2026-10-24 19:58:26.735	\N	\N
0f0d37c4-ce81-4c42-8ecf-f155ea347be9	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	204873a3-bdff-478c-bd70-8cd370df47f4	9b598ca0-efb8-48bd-b277-9c5b6af872b0	\N	\N	\N	\N	\N	\N	Casual Leather Sandal	Durable daily wear leather sandals.	\N	SHOE-SANDAL-013	f	f	0	clothingbrandstrike-casual-leather-sandal-1792871906744	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.744	2026-10-24 19:58:26.744	\N	\N
9d7c598a-dbdb-4ab2-bf06-277e66287d68	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	c9a87de0-bce7-42ec-abb3-e8cdf407183e	4d6fa67a-3950-489c-bfec-cdd33c19130d	\N	\N	\N	\N	\N	\N	Genuine Leather Formal Belt	Classic formal belt with metal buckle.	\N	ACC-BELT-014	f	t	0	clothingbrandstrike-genuine-leather-formal-belt-1792871906754	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.754	2026-10-24 19:58:26.754	\N	\N
9db7bb7f-bbcf-47c6-82e6-c83640206bc6	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	c9a87de0-bce7-42ec-abb3-e8cdf407183e	6fa56a84-74be-448b-95d5-68b62bd99994	\N	\N	\N	\N	\N	\N	UV Protection Fashion Sunglass	Stylish UV protected fashion sunglass.	\N	ACC-GLASS-015	t	f	0	clothingbrandstrike-uv-protection-fashion-sunglass-1792871906763	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.763	2026-10-24 19:58:26.763	\N	\N
43c8297b-4dc8-41b3-ad98-3411237a95b2	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	1d565b94-3d41-4232-b58b-bb06ab78bdf5	0a408976-54c5-4c7e-bffa-feab310dd05f	\N	\N	\N	\N	\N	\N	Kids Colorful Cotton Shirt	Colorful casual shirt for kids.	\N	KIDS-SHIRT-016	t	t	0	clothingbrandstrike-kids-colorful-cotton-shirt-1792871906772	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.772	2026-10-24 19:58:26.772	\N	\N
59423c56-cb3c-4972-857d-fde874e5a08a	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	1d565b94-3d41-4232-b58b-bb06ab78bdf5	83ace33e-3aa3-45e5-aa48-0fbdd1c3a4cd	\N	\N	\N	\N	\N	\N	Kids Warm Winter Jacket	Warm and cozy winter jacket for kids.	\N	KIDS-JCK-017	f	t	0	clothingbrandstrike-kids-warm-winter-jacket-1792871906782	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.782	2026-10-24 19:58:26.782	\N	\N
89bd7a27-277c-4dff-8520-6b8ba6003076	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	74342a43-b564-48b4-9b33-18c51aa6e213	81870d91-3f4a-44b5-aad3-bea04a543c34	\N	\N	\N	\N	\N	\N	Newborn Soft Cotton Romper (1M)	Soft cotton romper for 1 month baby.	\N	NB-1M-018	t	f	0	clothingbrandstrike-newborn-soft-cotton-romper-1m-1792871906791	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.792	2026-10-24 19:58:26.792	\N	\N
5fe94ebe-ec81-4ece-9546-1d1b64a2b3b1	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	74342a43-b564-48b4-9b33-18c51aa6e213	ec0d6bd8-f809-40dd-bdd4-380761c1a0a3	\N	\N	\N	\N	\N	\N	Newborn Clothing Set (6M)	Comfortable clothing set for 6 months baby.	\N	NB-6M-019	f	f	0	clothingbrandstrike-newborn-clothing-set-6m-1792871906799	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.8	2026-10-24 19:58:26.8	\N	\N
f2ecd448-5075-400c-bad2-b35a3b431488	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	74342a43-b564-48b4-9b33-18c51aa6e213	703d16bc-bd53-4e00-95b7-605f9e7357fd	\N	\N	\N	\N	\N	\N	Newborn Cute Outfit (10M)	Cute outfit for 10 months baby.	\N	NB-10M-020	t	f	0	clothingbrandstrike-newborn-cute-outfit-10m-1792871906808	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.808	2026-10-24 19:58:26.808	\N	\N
70bb4d05-6eed-4715-b25f-888701d99160	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	39a623bc-9948-45c9-935d-7f104dd61593	76995099-694a-42d7-a106-ef73cd5ba09c	\N	\N	\N	\N	\N	\N	Real Madrid Club Football Jersey	Fan edition club football jersey.	\N	JERSY-CL-021	t	t	0	clothingbrandstrike-real-madrid-club-football-jersey-1792871906815	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.816	2026-10-24 19:58:26.816	\N	\N
3d05dc8c-9258-4376-bd34-7ae5d607de69	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	39a623bc-9948-45c9-935d-7f104dd61593	76995099-694a-42d7-a106-ef73cd5ba09c	\N	\N	\N	\N	\N	\N	Argentina World Cup Football Jersey	Official style international team jersey.	\N	JERSY-INT-022	t	t	0	clothingbrandstrike-argentina-world-cup-football-jersey-1792871906824	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.825	2026-10-24 19:58:26.825	\N	\N
236dc197-0259-43c5-a617-211965cb79d3	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	39a623bc-9948-45c9-935d-7f104dd61593	67ccab7c-84cb-4bc1-9c54-14df05ac2635	\N	\N	\N	\N	\N	\N	Bangladesh National Cricket Jersey	Official fan edition cricket jersey.	\N	JERSY-CRK-023	t	t	0	clothingbrandstrike-bangladesh-national-cricket-jersey-1792871906833	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.834	2026-10-24 19:58:26.834	\N	\N
bb727eef-e84a-447a-8616-75d05d7295eb	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	39a623bc-9948-45c9-935d-7f104dd61593	67ccab7c-84cb-4bc1-9c54-14df05ac2635	\N	\N	\N	\N	\N	\N	IPL Team Cricket Jersey	Stylish cricket fan jersey.	\N	JERSY-CRK-024	f	f	0	clothingbrandstrike-ipl-team-cricket-jersey-1792871906843	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.843	2026-10-24 19:58:26.843	\N	\N
6c12238d-aca0-4b2d-9878-f4ccff229f5f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	a1e108b2-5ad2-4e81-93e6-cb15b278ecec	7adfc369-5b11-418a-8905-b2bb3b17204f	\N	\N	\N	\N	\N	\N	King Size Cotton Bed Sheet	King size comfortable printed bed sheet.	\N	HOME-BED-025	t	t	0	clothingbrandstrike-king-size-cotton-bed-sheet-1792871906852	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.853	2026-10-24 19:58:26.853	\N	\N
75344aab-495a-4514-9874-8e3dfd4b4c6c	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	a1e108b2-5ad2-4e81-93e6-cb15b278ecec	7adfc369-5b11-418a-8905-b2bb3b17204f	\N	\N	\N	\N	\N	\N	Luxury Floral Bed Sheet Set	Floral print luxury bed sheet with pillow covers.	\N	HOME-BED-026	f	f	0	clothingbrandstrike-luxury-floral-bed-sheet-set-1792871906860	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.861	2026-10-24 19:58:26.861	\N	\N
595623cb-ccdd-4b60-9d88-a6b2a41f6e8d	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	a1e108b2-5ad2-4e81-93e6-cb15b278ecec	e2b2217c-ca47-41a6-8f16-775cde5fb88f	\N	\N	\N	\N	\N	\N	Decorative Wooden Photo Frame	Decorative wall photo frame for home decor.	\N	HOME-FRM-027	f	f	0	clothingbrandstrike-decorative-wooden-photo-frame-1792871906868	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.869	2026-10-24 19:58:26.869	\N	\N
7ac3b222-81bc-4051-b492-27cf0142b6a5	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	a1e108b2-5ad2-4e81-93e6-cb15b278ecec	e2b2217c-ca47-41a6-8f16-775cde5fb88f	\N	\N	\N	\N	\N	\N	Modern Table Top Photo Frame	Elegant table top photo frame set.	\N	HOME-FRM-028	t	f	0	clothingbrandstrike-modern-table-top-photo-frame-1792871906877	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.878	2026-10-24 19:58:26.878	\N	\N
ee919d96-1dac-4543-964a-e0665d8e9dce	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	39a623bc-9948-45c9-935d-7f104dd61593	76995099-694a-42d7-a106-ef73cd5ba09c	\N	\N	\N	\N	\N	\N	Barcelona Away Club Football Jersey	Barcelona away edition football jersey.	\N	JERSY-CL-029	f	f	0	clothingbrandstrike-barcelona-away-club-football-jersey-1792871906887	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.887	2026-10-24 19:58:26.887	\N	\N
6a962db6-57a7-452c-b531-e85eb8124381	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	39a623bc-9948-45c9-935d-7f104dd61593	76995099-694a-42d7-a106-ef73cd5ba09c	\N	\N	\N	\N	\N	\N	Brazil National Home Football Jersey	Classic yellow national football jersey.	\N	JERSY-INT-030	t	f	0	clothingbrandstrike-brazil-national-home-football-jersey-1792871906896	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 19:58:26.896	2026-10-24 19:58:26.896	\N	\N
4ed57174-1e05-4c61-b41f-2b3ea9c04474	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	204873a3-bdff-478c-bd70-8cd370df47f4	b562e88b-35c6-48e0-baf1-e810fd335869	\N	\N	\N	\N	\N	\N	Men Formal Oxford Shoes	Classic formal leather shoes for men.	\N	SHOE-FORMAL-121	f	t	0	clothingbrandstrike-men-formal-oxford-shoes-1792872236333	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.332	2026-10-24 20:03:56.332	\N	\N
38069b07-6fd4-4a53-9d7c-ff6e52ebfdec	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	204873a3-bdff-478c-bd70-8cd370df47f4	b562e88b-35c6-48e0-baf1-e810fd335869	\N	\N	\N	\N	\N	\N	Men Leather Brogue Formal Shoes	Elegant leather brogue formal shoes.	\N	SHOE-FORMAL-122	t	f	0	clothingbrandstrike-men-leather-brogue-formal-shoes-1792872236361	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.361	2026-10-24 20:03:56.361	\N	\N
cd777e93-c96c-4ef3-90d3-42c240452c79	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	204873a3-bdff-478c-bd70-8cd370df47f4	b562e88b-35c6-48e0-baf1-e810fd335869	\N	\N	\N	\N	\N	\N	Men Slip-On Leather Loafers	Comfortable formal and casual leather loafers.	\N	SHOE-FORMAL-123	f	t	0	clothingbrandstrike-men-slip-on-leather-loafers-1792872236380	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.38	2026-10-24 20:03:56.38	\N	\N
577a4010-5a2b-405a-a8d2-4b066bcf4372	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	204873a3-bdff-478c-bd70-8cd370df47f4	041300cc-2e52-4aab-abdd-0472896fd3be	\N	\N	\N	\N	\N	\N	Pro Athletic Running Sneakers	Professional athletic running sneakers.	\N	SHOE-SNEAK-124	t	t	0	clothingbrandstrike-pro-athletic-running-sneakers-1792872236401	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.401	2026-10-24 20:03:56.401	\N	\N
28e5cb99-585c-4d50-a9aa-ca51f3770849	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	204873a3-bdff-478c-bd70-8cd370df47f4	041300cc-2e52-4aab-abdd-0472896fd3be	\N	\N	\N	\N	\N	\N	Mesh Breathable Sports Gym Shoes	Lightweight mesh breathable gym shoes.	\N	SHOE-SNEAK-125	f	f	0	clothingbrandstrike-mesh-breathable-sports-gym-shoes-1792872236420	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.42	2026-10-24 20:03:56.42	\N	\N
bb146b31-8b60-43ed-a111-42ea9857c147	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	204873a3-bdff-478c-bd70-8cd370df47f4	041300cc-2e52-4aab-abdd-0472896fd3be	\N	\N	\N	\N	\N	\N	Casual Canvas Sneakers	Stylish casual canvas sneakers for daily wear.	\N	SHOE-SNEAK-126	t	f	0	clothingbrandstrike-casual-canvas-sneakers-1792872236440	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.44	2026-10-24 20:03:56.44	\N	\N
89df97a3-38e3-4c2f-ad60-744d1bf7268a	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	204873a3-bdff-478c-bd70-8cd370df47f4	9b598ca0-efb8-48bd-b277-9c5b6af872b0	\N	\N	\N	\N	\N	\N	Outdoor Casual Leather Sandal	Durable outdoor casual leather sandals.	\N	SHOE-SANDAL-127	f	f	0	clothingbrandstrike-outdoor-casual-leather-sandal-1792872236460	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.46	2026-10-24 20:03:56.46	\N	\N
0c9c47a1-7ad0-44d8-84e4-4749ed749ce8	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	204873a3-bdff-478c-bd70-8cd370df47f4	9b598ca0-efb8-48bd-b277-9c5b6af872b0	\N	\N	\N	\N	\N	\N	Comfort Orthopedic Leather Sandal	Comfortable orthotic daily wear leather sandal.	\N	SHOE-SANDAL-128	t	f	0	clothingbrandstrike-comfort-orthopedic-leather-sandal-1792872236478	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.479	2026-10-24 20:03:56.479	\N	\N
01202189-9e12-43b5-b326-d2324501ed7e	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	162123b5-cd08-4c06-b00b-9bcad9b6bbc7	\N	\N	\N	\N	\N	\N	Men Premium Oxford Full Sleeve Shirt	Premium cotton formal full sleeve shirt.	\N	SHIRT-FS-129	t	t	0	clothingbrandstrike-men-premium-oxford-full-sleeve-shirt-1792872236498	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.498	2026-10-24 20:03:56.498	\N	\N
f879d781-a80d-49db-a89f-5696b0cb9e8b	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	162123b5-cd08-4c06-b00b-9bcad9b6bbc7	bbe56d99-e69f-4cc2-9954-77c1bd9f7236	\N	\N	\N	\N	\N	Men Business Slim Fit Shirt	Business slim fit professional formal shirt.	\N	SHIRT-FM-130	f	t	0	clothingbrandstrike-men-business-slim-fit-shirt-1792872236514	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.515	2026-10-24 20:03:56.515	\N	\N
f3bb6102-568b-4ca1-b0e5-e4288083c0a9	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	162123b5-cd08-4c06-b00b-9bcad9b6bbc7	\N	\N	\N	\N	\N	\N	Men Casual Half Sleeve Check Shirt	Stylish checkered half sleeve casual shirt.	\N	SHIRT-HS-131	f	f	0	clothingbrandstrike-men-casual-half-sleeve-check-shirt-1792872236531	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.531	2026-10-24 20:03:56.531	\N	\N
76572a8c-9d93-4f7e-9e4b-0b396ef9a742	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	162123b5-cd08-4c06-b00b-9bcad9b6bbc7	\N	\N	\N	\N	\N	\N	Men Summer Beach Casual Shirt	Lightweight half sleeve summer wear shirt.	\N	SHIRT-HS-132	t	f	0	clothingbrandstrike-men-summer-beach-casual-shirt-1792872236547	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.547	2026-10-24 20:03:56.547	\N	\N
8aa29284-2997-4130-bc55-a213eb620567	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	b09305fb-3470-4f62-a4a9-576813e3fb8d	88ae1a34-ea1c-4704-ae77-0b6a346955b6	\N	\N	\N	\N	\N	\N	Women Designer Party Wear Kurti	Elegant traditional embroidered kurti.	\N	WOMEN-KURTI-133	t	t	0	clothingbrandstrike-women-designer-party-wear-kurti-1792872236569	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.569	2026-10-24 20:03:56.569	\N	\N
00dcbfd7-09e0-444d-8914-9a5c26b4ac8f	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	b09305fb-3470-4f62-a4a9-576813e3fb8d	88ae1a34-ea1c-4704-ae77-0b6a346955b6	\N	\N	\N	\N	\N	\N	Women Daily Comfort Cotton Kurti	Soft cotton daily wear printed kurti.	\N	WOMEN-KURTI-134	f	f	0	clothingbrandstrike-women-daily-comfort-cotton-kurti-1792872236586	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.586	2026-10-24 20:03:56.586	\N	\N
d33c9a0f-7907-4cab-a8a2-d6e8bb27dd6a	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	b09305fb-3470-4f62-a4a9-576813e3fb8d	88ae1a34-ea1c-4704-ae77-0b6a346955b6	\N	\N	\N	\N	\N	\N	Women Casual Lawn Kurti	Breathable lawn fabric casual kurti.	\N	WOMEN-KURTI-135	f	f	0	clothingbrandstrike-women-casual-lawn-kurti-1792872236601	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.602	2026-10-24 20:03:56.602	\N	\N
7901703c-e519-4da1-a4b3-86939d3cfe3e	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	b09305fb-3470-4f62-a4a9-576813e3fb8d	88ae1a34-ea1c-4704-ae77-0b6a346955b6	\N	\N	\N	\N	\N	\N	Women Party Wear Anarkali Kurti	Stunning party wear anarkali style kurti.	\N	WOMEN-KURTI-136	t	t	0	clothingbrandstrike-women-party-wear-anarkali-kurti-1792872236620	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.62	2026-10-24 20:03:56.62	\N	\N
2099a22c-4955-44c4-af6b-6616e133247e	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	b09305fb-3470-4f62-a4a9-576813e3fb8d	488ef54a-c290-474f-be0c-ce9ee125e7b1	\N	\N	\N	\N	\N	\N	Women New IN Elegant Gown	Exclusive new collection designer gown.	\N	WOMEN-NEW-137	t	t	0	clothingbrandstrike-women-new-in-elegant-gown-1792872236636	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.636	2026-10-24 20:03:56.636	\N	\N
5f5cc789-3c3d-4465-996d-cdd8fd8b90bb	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	b09305fb-3470-4f62-a4a9-576813e3fb8d	488ef54a-c290-474f-be0c-ce9ee125e7b1	\N	\N	\N	\N	\N	\N	Women New IN Trendy Maxi Dress	Trendy new arrival western maxi dress.	\N	WOMEN-NEW-138	f	f	0	clothingbrandstrike-women-new-in-trendy-maxi-dress-1792872236653	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.653	2026-10-24 20:03:56.653	\N	\N
b15ba6e3-7ad4-437a-8f23-5db2ce4c7f3e	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	b09305fb-3470-4f62-a4a9-576813e3fb8d	488ef54a-c290-474f-be0c-ce9ee125e7b1	\N	\N	\N	\N	\N	\N	Women New IN Floral Party Dress	Floral print new collection party dress.	\N	WOMEN-NEW-139	f	f	0	clothingbrandstrike-women-new-in-floral-party-dress-1792872236696	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.696	2026-10-24 20:03:56.696	\N	\N
fcd96dd4-e631-46bd-b5e8-ff564ce5dea7	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	b09305fb-3470-4f62-a4a9-576813e3fb8d	488ef54a-c290-474f-be0c-ce9ee125e7b1	\N	\N	\N	\N	\N	\N	Women New IN Western Party Outfit	Stylish western party wear outfit.	\N	WOMEN-NEW-140	t	t	0	clothingbrandstrike-women-new-in-western-party-outfit-1792872236715	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.715	2026-10-24 20:03:56.715	\N	\N
bfa9b3b5-38cb-4d63-8501-694125f75f63	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	b669cc73-17ee-4e6d-adba-d1614f262971	\N	\N	\N	\N	\N	\N	Men Gabardine Formal Trouser	Premium gabardine formal trousers for office.	\N	PANT-FORMAL-141	f	f	0	clothingbrandstrike-men-gabardine-formal-trouser-1792872236734	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.735	2026-10-24 20:03:56.735	\N	\N
fb08a2dc-2287-4702-b88c-4a60ccea278c	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	b669cc73-17ee-4e6d-adba-d1614f262971	\N	\N	\N	\N	\N	\N	Men Chino Casual Trouser	Comfortable cotton blend chino trousers.	\N	PANT-FORMAL-142	t	f	0	clothingbrandstrike-men-chino-casual-trouser-1792872236753	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.754	2026-10-24 20:03:56.754	\N	\N
b6bcf5c0-6006-491b-bdbe-e637e0e8fcdc	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	b669cc73-17ee-4e6d-adba-d1614f262971	\N	\N	\N	\N	\N	\N	Men Stretchable Cotton Trouser	Flexible stretchable cotton formal trouser.	\N	PANT-FORMAL-143	f	f	0	clothingbrandstrike-men-stretchable-cotton-trouser-1792872236771	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.771	2026-10-24 20:03:56.771	\N	\N
62c78000-e142-448a-a870-3e74bc7fabfa	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	b669cc73-17ee-4e6d-adba-d1614f262971	\N	\N	\N	\N	\N	\N	Men Heavy Duty Stretch Denim Jeans	Durable heavy duty blue denim jeans pant.	\N	PANT-JEANS-144	t	t	0	clothingbrandstrike-men-heavy-duty-stretch-denim-jeans-1792872236786	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.787	2026-10-24 20:03:56.787	\N	\N
570a2ef9-68b3-48a1-9eec-e0a1b7613714	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	b669cc73-17ee-4e6d-adba-d1614f262971	\N	\N	\N	\N	\N	\N	Men Slim Fit Black Jeans	Modern slim fit black denim jeans.	\N	PANT-JEANS-145	f	t	0	clothingbrandstrike-men-slim-fit-black-jeans-1792872236803	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.804	2026-10-24 20:03:56.804	\N	\N
a79405f9-9b42-4c8e-8d97-6e6b28a7be3a	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	553c3bb0-4e4d-4573-9f30-1eaaa11fdfe9	\N	\N	\N	\N	\N	\N	Men Classic Cotton Polo Shirt	High quality solid color cotton polo shirt.	\N	POLO-146	t	f	0	clothingbrandstrike-men-classic-cotton-polo-shirt-1792872236819	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.82	2026-10-24 20:03:56.82	\N	\N
247c17ed-3853-462e-b4a2-1c4f4fbfce35	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	553c3bb0-4e4d-4573-9f30-1eaaa11fdfe9	\N	\N	\N	\N	\N	\N	Men Sports Dry-Fit Polo Shirt	Dry-fit breathable sports polo t-shirt.	\N	POLO-147	f	f	0	clothingbrandstrike-men-sports-dry-fit-polo-shirt-1792872236836	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.836	2026-10-24 20:03:56.836	\N	\N
1a4f4714-447c-449d-b68f-4a339d535f5c	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	553c3bb0-4e4d-4573-9f30-1eaaa11fdfe9	\N	\N	\N	\N	\N	\N	Men Striped Casual Polo	Casual striped design cotton polo shirt.	\N	POLO-148	f	f	0	clothingbrandstrike-men-striped-casual-polo-1792872236852	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.852	2026-10-24 20:03:56.852	\N	\N
3657f403-d21f-414d-8fe0-c8535b8ebdca	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	553c3bb0-4e4d-4573-9f30-1eaaa11fdfe9	\N	\N	\N	\N	\N	\N	Men Premium Collar Polo	Classic collar design premium cotton polo.	\N	POLO-149	f	t	0	clothingbrandstrike-men-premium-collar-polo-1792872236869	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.869	2026-10-24 20:03:56.869	\N	\N
c530f1c8-97d7-4573-8ecf-62c63593a252	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	5d9071c7-aa35-4165-83b1-b8a6468ad556	162123b5-cd08-4c06-b00b-9bcad9b6bbc7	bbe56d99-e69f-4cc2-9954-77c1bd9f7236	\N	\N	\N	\N	\N	Men Formal Office Shirt (Solid)	Solid color professional formal office shirt.	\N	SHIRT-FM-150	t	f	0	clothingbrandstrike-men-formal-office-shirt-solid-1792872236885	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	\N	t	f	2026-10-24 20:03:56.885	2026-10-24 20:03:56.885	\N	\N
1240a18c-cc9b-4050-a1aa-f97249d0b4b9	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	39a623bc-9948-45c9-935d-7f104dd61593	76995099-694a-42d7-a106-ef73cd5ba09c	3b249463-1907-4598-82dc-819b1f83e018	\N	\N	\N	\N	\N	Argentina World Cup Jersey	Official style international jersey.	\N	JERSY-INT-008	t	t	0	clothingbrandstrike-argentina-world-cup-jersey-1792871581490	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	\N	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	t	t	2026-10-24 19:53:01.491	2026-10-25 19:41:11.949	\N	\N
\.


--
-- Data for Name: ProductAttribute; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."ProductAttribute" (id, "productId", size, "costPrice", "retailPrice", "discountPercent", "discountPrice", "discountedRetailPrice", "stockAmount", "isDeleted", "createdBy", "updatedBy", "deletedBy", "createdAt", "updatedAt") FROM stdin;
f361337a-12d6-4755-b13d-2ea300702061	e71f9fad-272e-4aab-965f-a394e68380be	30	700	1800	10	180	1620	40	t	\N	\N	\N	2026-10-24 19:53:01.465	2026-10-25 19:41:26.68
26598848-bb01-4c7e-be36-00faa0895a8f	9c4dfc17-0be9-4abd-ba0f-0dfd49aeb0cf	Size: L	1500	1950	10	195	1755	1199	f	\N	\N	\N	2026-10-24 09:27:38.324	2026-10-24 20:23:16.369
f9c82b7e-06e7-4a53-8196-7f019d6325b9	9c4dfc17-0be9-4abd-ba0f-0dfd49aeb0cf	Size: M	1500	1950	10	195	1755	1200	f	\N	\N	\N	2026-10-24 09:27:38.324	2026-10-24 09:37:14.358
cce9c1b1-4365-4c23-9058-024333d21965	1240a18c-cc9b-4050-a1aa-f97249d0b4b9	M	320	800	0	0	800	70	t	\N	\N	\N	2026-10-24 19:53:01.491	2026-10-25 19:41:11.949
4648a028-8f27-488d-8503-f3708b3d8848	9c4dfc17-0be9-4abd-ba0f-0dfd49aeb0cf	Size: S	1500	1950	10	195	1755	113	f	\N	\N	\N	2026-10-24 09:27:38.324	2026-10-24 18:15:31.539
57988b58-6517-4b4f-b396-96431d117c25	6e3a75fe-be49-4e90-ba55-452458ca8db2	M	450	1150	10	115	1035	20	f	\N	\N	\N	2026-10-24 19:55:25.041	2026-10-24 19:55:25.041
fcf2d6a3-a1ac-4c47-813c-f9f4504852c8	6e3a75fe-be49-4e90-ba55-452458ca8db2	L	450	1150	10	115	1035	25	f	\N	\N	\N	2026-10-24 19:55:25.041	2026-10-24 19:55:25.041
2cd5c3d4-ca11-4b91-8ec4-3250cfe23e35	c90772e3-8704-4479-bcf0-ddb20fb726be	S	380	950	10	95	855	30	f	\N	\N	\N	2026-10-24 19:55:25.052	2026-10-24 19:55:25.052
08bee8f0-5281-4a51-bff0-83955a01dba9	c90772e3-8704-4479-bcf0-ddb20fb726be	M	380	950	10	95	855	40	f	\N	\N	\N	2026-10-24 19:55:25.052	2026-10-24 19:55:25.052
2759f007-25e1-4e4a-b189-8dc56853499a	ae7c9c8d-086a-4e84-a419-33871d80d88f	M	500	1300	10	130	1170	25	f	\N	\N	\N	2026-10-24 19:55:25.061	2026-10-24 19:55:25.061
696274c2-4c98-4824-b5c6-3b0d465cf1d5	dab94f06-0e68-44c8-b458-c00011013d51	S	420	1050	10	105	945	15	f	\N	\N	\N	2026-10-24 19:55:25.07	2026-10-24 19:55:25.07
7e77d87a-f9ba-4e3f-8a5d-8cc2766ca161	dab94f06-0e68-44c8-b458-c00011013d51	M	420	1050	10	105	945	25	f	\N	\N	\N	2026-10-24 19:55:25.07	2026-10-24 19:55:25.07
766f715f-5b43-465e-9472-42483f0a4ef4	0ceab60b-154c-4f0a-b16f-4d8e6628b1e5	32	600	1500	10	150	1350	30	f	\N	\N	\N	2026-10-24 19:55:25.079	2026-10-24 19:55:25.079
48930b68-5b38-4c04-8fb9-67375c330136	4e8ad248-7b05-42bf-9974-95ded09be7b3	30	700	1800	10	180	1620	40	f	\N	\N	\N	2026-10-24 19:55:25.088	2026-10-24 19:55:25.088
835c3779-89b4-4453-b27f-6842ac17e4b8	4e8ad248-7b05-42bf-9974-95ded09be7b3	32	700	1800	10	180	1620	35	f	\N	\N	\N	2026-10-24 19:55:25.088	2026-10-24 19:55:25.088
f424c6f0-fed8-49e0-a63f-1980c9453e68	ecbc1023-f440-4569-8772-0409b82150ae	M	300	750	0	0	750	50	f	\N	\N	\N	2026-10-24 19:55:25.098	2026-10-24 19:55:25.098
2b37e6b9-2096-4f75-a810-d39efbb2e518	ecbc1023-f440-4569-8772-0409b82150ae	L	300	750	0	0	750	60	f	\N	\N	\N	2026-10-24 19:55:25.098	2026-10-24 19:55:25.098
39c223d8-0025-4a97-8d46-f47c4292f4c5	9b728cfe-d1d2-44ea-bec4-379216652a51	M	320	800	0	0	800	70	f	\N	\N	\N	2026-10-24 19:55:25.107	2026-10-24 19:55:25.107
448720ca-7717-4029-8b7f-c5cd50fc0d29	1240a18c-cc9b-4050-a1aa-f97249d0b4b9	L	320	800	0	0	800	85	t	\N	\N	\N	2026-10-24 19:53:01.491	2026-10-25 19:41:11.949
01fcaa16-f15b-43da-a590-e2294ff08105	8eb6e435-c1fc-4206-ba03-6f1a6f359eac	M	300	750	0	0	750	50	t	\N	\N	\N	2026-10-24 19:53:01.476	2026-10-25 19:41:17.55
37559854-3e09-48d4-a385-69c3cbb45e28	8eb6e435-c1fc-4206-ba03-6f1a6f359eac	L	300	750	0	0	750	60	t	\N	\N	\N	2026-10-24 19:53:01.476	2026-10-25 19:41:17.55
b3bcc5f1-ae71-4815-9c00-9987e463b3bc	e71f9fad-272e-4aab-965f-a394e68380be	32	700	1800	10	180	1620	35	t	\N	\N	\N	2026-10-24 19:53:01.465	2026-10-25 19:41:26.68
bc01fb34-62a5-4584-8c18-c8015c13ae3d	a2146adb-df43-4993-9013-34aba09c624a	M	450	1150	10	115	1035	20	t	\N	\N	\N	2026-10-24 19:53:01.31	2026-10-25 19:41:40.121
a4d75194-14e7-414a-add1-d9b7fb785432	a2146adb-df43-4993-9013-34aba09c624a	L	450	1150	10	115	1035	25	t	\N	\N	\N	2026-10-24 19:53:01.31	2026-10-25 19:41:40.121
60b894ac-d020-4973-8a46-27d449987b9f	60bd6453-f492-4aab-bf27-15a4b41b4a62	S	380	950	10	95	855	30	t	\N	\N	\N	2026-10-24 19:53:01.351	2026-10-25 19:41:44.702
2140bea7-759a-4fb3-99a1-be7cac0619b1	60bd6453-f492-4aab-bf27-15a4b41b4a62	M	380	950	10	95	855	40	t	\N	\N	\N	2026-10-24 19:53:01.351	2026-10-25 19:41:44.702
a51e6a69-ff59-4a28-a5d4-8916cfae2e3d	9db63b45-9a3c-4f48-8426-0b77c5de7eb7	M	500	1300	10	130	1170	25	t	\N	\N	\N	2026-10-24 19:53:01.368	2026-10-25 19:41:48.558
d83542e8-fd6a-44dc-9438-172d441664b9	9db63b45-9a3c-4f48-8426-0b77c5de7eb7	L	500	1300	10	130	1170	35	t	\N	\N	\N	2026-10-24 19:53:01.368	2026-10-25 19:41:48.558
ce7c7c53-5de7-44db-91f1-b13fb62ec852	719f5b65-c98e-453d-bcc7-ac8ee78a442f	S	420	1050	10	105	945	15	t	\N	\N	\N	2026-10-24 19:53:01.379	2026-10-25 19:41:54.302
ce7ac8ad-0c1e-4ba5-80ce-3606919cddad	719f5b65-c98e-453d-bcc7-ac8ee78a442f	M	420	1050	10	105	945	25	t	\N	\N	\N	2026-10-24 19:53:01.379	2026-10-25 19:41:54.302
2b8d811b-6516-4caa-b40c-7325769bcd55	e4364168-964f-43b9-b2ec-3bfba2477e85	30	600	1500	10	150	1350	20	t	\N	\N	\N	2026-10-24 19:53:01.39	2026-10-25 19:41:57.821
f175933e-956f-46ab-9f62-df957d1a490e	e4364168-964f-43b9-b2ec-3bfba2477e85	32	600	1500	10	150	1350	30	t	\N	\N	\N	2026-10-24 19:53:01.39	2026-10-25 19:41:57.821
f229e8cc-118e-4521-97fa-6e9df52a64cd	ae7c9c8d-086a-4e84-a419-33871d80d88f	L	500	1300	10	130	1170	34	f	\N	\N	\N	2026-10-24 19:55:25.061	2026-10-25 20:39:18.082
3f4730e6-4af1-4457-8e37-ff66d566b681	0ceab60b-154c-4f0a-b16f-4d8e6628b1e5	30	600	1500	10	150	1350	19	f	\N	\N	\N	2026-10-24 19:55:25.079	2026-10-25 20:39:18.082
938f8213-0f92-46bb-b436-c5090f64bcfe	9c4dfc17-0be9-4abd-ba0f-0dfd49aeb0cf	Size: XL	1500	1950	10	195	1755	1198	f	\N	\N	\N	2026-10-24 09:27:38.324	2026-10-26 19:44:02.266
bfb6f8ef-0fb3-42ae-bfb5-b898ba1d8a2e	9b728cfe-d1d2-44ea-bec4-379216652a51	L	320	800	0	0	800	85	f	\N	\N	\N	2026-10-24 19:55:25.107	2026-10-24 19:55:25.107
b2e5edaa-3af1-4444-8f72-f573bbba536a	e89d6f03-391c-48c3-84ce-02e1e28a6ec6	M	450	1150	10	115	1035	20	f	\N	\N	\N	2026-10-24 19:58:26.601	2026-10-24 19:58:26.601
2120432f-f9c5-4479-93f3-6f3295023af6	e89d6f03-391c-48c3-84ce-02e1e28a6ec6	L	450	1150	10	115	1035	25	f	\N	\N	\N	2026-10-24 19:58:26.601	2026-10-24 19:58:26.601
ed86c1f5-cca0-4e28-8a40-ee50cc24ff7c	e17bfcd9-17b0-4adb-be18-d7d8f1e8d7f1	S	380	950	10	95	855	30	f	\N	\N	\N	2026-10-24 19:58:26.639	2026-10-24 19:58:26.639
ddec1b99-bd8e-43a3-840c-b7d0b811aa57	e17bfcd9-17b0-4adb-be18-d7d8f1e8d7f1	M	380	950	10	95	855	40	f	\N	\N	\N	2026-10-24 19:58:26.639	2026-10-24 19:58:26.639
5b02158b-51e6-46a1-96a9-916d83d7aca9	71d4df0b-e4a9-4c8a-aa54-317261858859	M	500	1250	0	0	1250	25	f	\N	\N	\N	2026-10-24 19:58:26.65	2026-10-24 19:58:26.65
13ccdcd2-507d-443a-9726-c75183d1b039	71d4df0b-e4a9-4c8a-aa54-317261858859	L	500	1250	0	0	1250	25	f	\N	\N	\N	2026-10-24 19:58:26.65	2026-10-24 19:58:26.65
53606e94-49bc-4fbd-9309-1ed530dbe004	9ea58a0c-9562-4d62-a59d-77ca5fe66741	S	420	1050	0	0	1050	20	f	\N	\N	\N	2026-10-24 19:58:26.659	2026-10-24 19:58:26.659
b34fc27e-ad0c-4608-a950-4a81ae1a0a4c	9ea58a0c-9562-4d62-a59d-77ca5fe66741	M	420	1050	0	0	1050	30	f	\N	\N	\N	2026-10-24 19:58:26.659	2026-10-24 19:58:26.659
94b0b5c2-f1ed-4558-8402-c60a4c1c8883	da2ae24e-1027-45b7-a7ba-6e0c4a66f678	M	750	1850	0	0	1850	15	f	\N	\N	\N	2026-10-24 19:58:26.669	2026-10-24 19:58:26.669
44ce6f1b-3295-4ca3-88ee-7b3ae54f782c	da2ae24e-1027-45b7-a7ba-6e0c4a66f678	L	750	1850	0	0	1850	15	f	\N	\N	\N	2026-10-24 19:58:26.669	2026-10-24 19:58:26.669
6854ae06-dc8a-48e4-8708-1510e78bdc94	43d3274b-0bc4-4c12-98ff-af2350f69402	S	650	1600	0	0	1600	20	f	\N	\N	\N	2026-10-24 19:58:26.679	2026-10-24 19:58:26.679
3038c029-3ed8-407c-b582-33e4fdbb0ea5	d6d2ff2b-b9b3-4e46-9225-9ab39bae6071	30	600	1500	10	150	1350	20	f	\N	\N	\N	2026-10-24 19:58:26.687	2026-10-24 19:58:26.687
6076f177-2420-4aff-87f7-1cffdc8ab328	d6d2ff2b-b9b3-4e46-9225-9ab39bae6071	32	600	1500	10	150	1350	25	f	\N	\N	\N	2026-10-24 19:58:26.687	2026-10-24 19:58:26.687
7161bb6b-6adb-4e6e-9fba-607619def318	7626fb97-054a-4be1-ac2f-827fb07a479f	30	700	1800	10	180	1620	30	f	\N	\N	\N	2026-10-24 19:58:26.696	2026-10-24 19:58:26.696
ef95f781-4841-45b9-87d4-c61ad7109184	7626fb97-054a-4be1-ac2f-827fb07a479f	34	700	1800	10	180	1620	35	f	\N	\N	\N	2026-10-24 19:58:26.696	2026-10-24 19:58:26.696
3e15bc00-3aba-490f-9964-fe1e8f172e21	2c968541-ab7c-42f5-b976-7383fad98ab8	M	350	850	10	85	765	40	f	\N	\N	\N	2026-10-24 19:58:26.706	2026-10-24 19:58:26.706
3efa4036-a889-4fc8-ab6f-6f61a16e7dd4	2c968541-ab7c-42f5-b976-7383fad98ab8	L	350	850	10	85	765	40	f	\N	\N	\N	2026-10-24 19:58:26.706	2026-10-24 19:58:26.706
84c2f297-52d7-4f70-887d-ea2be178a44a	a7ec4f21-b399-40c5-8039-a020818df6c3	L	370	900	10	90	810	25	f	\N	\N	\N	2026-10-24 19:58:26.715	2026-10-24 19:58:26.715
df888d6f-cd67-417d-bc1d-e21ac3ea6473	a7ec4f21-b399-40c5-8039-a020818df6c3	XL	370	900	10	90	810	20	f	\N	\N	\N	2026-10-24 19:58:26.715	2026-10-24 19:58:26.715
53081118-1566-43b4-9155-ed41245908d0	ef7e970f-a415-45f4-b98b-0aa741925ea3	42	950	2300	0	0	2300	20	f	\N	\N	\N	2026-10-24 19:58:26.726	2026-10-24 19:58:26.726
97fb47fa-bf0a-4996-ab6f-cd73a8a84fd9	1a0b08b6-6f05-4cbf-bbb8-004e256223cd	41	850	2000	0	0	2000	25	f	\N	\N	\N	2026-10-24 19:58:26.735	2026-10-24 19:58:26.735
0409891f-9f02-4cad-b15b-e9a60f596474	1a0b08b6-6f05-4cbf-bbb8-004e256223cd	43	850	2000	0	0	2000	30	f	\N	\N	\N	2026-10-24 19:58:26.735	2026-10-24 19:58:26.735
42d9ae52-0138-4ff2-80c3-0dc0532dd247	0f0d37c4-ce81-4c42-8ecf-f155ea347be9	40	400	990	0	0	990	20	f	\N	\N	\N	2026-10-24 19:58:26.744	2026-10-24 19:58:26.744
a6511a25-d14a-4bd1-b0a8-3162714989cd	0f0d37c4-ce81-4c42-8ecf-f155ea347be9	42	400	990	0	0	990	20	f	\N	\N	\N	2026-10-24 19:58:26.744	2026-10-24 19:58:26.744
13722367-4e23-4739-b17e-a4fcb7a74ba7	43c8297b-4dc8-41b3-ad98-3411237a95b2	5-6Y	280	750	0	0	750	25	f	\N	\N	\N	2026-10-24 19:58:26.772	2026-10-24 19:58:26.772
0f1b3d21-1ffa-447e-9595-64b3988376d8	43c8297b-4dc8-41b3-ad98-3411237a95b2	7-8Y	280	750	0	0	750	25	f	\N	\N	\N	2026-10-24 19:58:26.772	2026-10-24 19:58:26.772
d52822ea-076b-48dd-a2ca-04b9d84f7ed3	59423c56-cb3c-4972-857d-fde874e5a08a	4-5Y	550	1400	0	0	1400	15	f	\N	\N	\N	2026-10-24 19:58:26.782	2026-10-24 19:58:26.782
983ab4f3-b4ab-44bf-996b-26434c62d078	59423c56-cb3c-4972-857d-fde874e5a08a	6-7Y	550	1400	0	0	1400	20	f	\N	\N	\N	2026-10-24 19:58:26.782	2026-10-24 19:58:26.782
d2ed3625-9b78-4466-a9f9-352b318fbe49	89bd7a27-277c-4dff-8520-6b8ba6003076	0-1M	200	500	0	0	500	30	f	\N	\N	\N	2026-10-24 19:58:26.792	2026-10-24 19:58:26.792
a8b70860-304b-4b5d-9723-b515298c6db0	5fe94ebe-ec81-4ece-9546-1d1b64a2b3b1	3-6M	220	550	0	0	550	25	f	\N	\N	\N	2026-10-24 19:58:26.8	2026-10-24 19:58:26.8
130ca0a4-61be-4017-8f3a-45ad7334c140	f2ecd448-5075-400c-bad2-b35a3b431488	9-12M	250	600	0	0	600	20	f	\N	\N	\N	2026-10-24 19:58:26.808	2026-10-24 19:58:26.808
5684b5ab-e0c3-4ac0-8e10-e4e817b8ccfc	70bb4d05-6eed-4715-b25f-888701d99160	M	300	750	0	0	750	50	f	\N	\N	\N	2026-10-24 19:58:26.816	2026-10-24 19:58:26.816
b9096308-6a0f-41ba-bc9d-6d6419f7a8ec	70bb4d05-6eed-4715-b25f-888701d99160	L	300	750	0	0	750	60	f	\N	\N	\N	2026-10-24 19:58:26.816	2026-10-24 19:58:26.816
67e48e53-a489-4b43-9b1d-ee6fe22b46c7	3d05dc8c-9258-4376-bd34-7ae5d607de69	M	320	800	0	0	800	70	f	\N	\N	\N	2026-10-24 19:58:26.825	2026-10-24 19:58:26.825
72f56299-b3a4-412c-83d4-87c0782207f9	3d05dc8c-9258-4376-bd34-7ae5d607de69	L	320	800	0	0	800	85	f	\N	\N	\N	2026-10-24 19:58:26.825	2026-10-24 19:58:26.825
fdefca2d-931e-454f-9368-8d2f55fb1811	236dc197-0259-43c5-a617-211965cb79d3	L	320	800	0	0	800	50	f	\N	\N	\N	2026-10-24 19:58:26.834	2026-10-24 19:58:26.834
1458c869-600d-4d05-af5d-9af7248ad510	bb727eef-e84a-447a-8616-75d05d7295eb	M	300	750	0	0	750	30	f	\N	\N	\N	2026-10-24 19:58:26.843	2026-10-24 19:58:26.843
5c369a50-8202-4da7-9c91-1f06e804dca2	9d7c598a-dbdb-4ab2-bf06-277e66287d68	34	250	650	0	0	650	38	f	\N	\N	\N	2026-10-24 19:58:26.754	2026-10-26 19:44:02.266
1229d932-9dbe-4757-b42f-e879a970f34b	9db7bb7f-bbcf-47c6-82e6-c83640206bc6	Free	300	850	0	0	850	49	f	\N	\N	\N	2026-10-24 19:58:26.763	2026-10-26 19:44:02.266
29a7d60a-0a29-46b3-9d02-2097d0e78c96	236dc197-0259-43c5-a617-211965cb79d3	M	320	800	0	0	800	44	f	\N	\N	\N	2026-10-24 19:58:26.834	2026-11-01 17:51:51.31
c271c1e0-d45f-43d0-8c97-bc24e14358a0	bb727eef-e84a-447a-8616-75d05d7295eb	L	300	750	0	0	750	30	f	\N	\N	\N	2026-10-24 19:58:26.843	2026-10-24 19:58:26.843
24a8f096-43af-436b-a13a-9f13fef3fb54	6c12238d-aca0-4b2d-9878-f4ccff229f5f	King	650	1600	0	0	1600	15	f	\N	\N	\N	2026-10-24 19:58:26.853	2026-10-24 19:58:26.853
f43f3a0d-d6b8-4d5c-bea9-634a62a17693	75344aab-495a-4514-9874-8e3dfd4b4c6c	King	700	1750	0	0	1750	12	f	\N	\N	\N	2026-10-24 19:58:26.861	2026-10-24 19:58:26.861
dfce4ca9-3588-4ea0-b482-0d64d2dcbfa0	595623cb-ccdd-4b60-9d88-a6b2a41f6e8d	Standard	180	450	0	0	450	30	f	\N	\N	\N	2026-10-24 19:58:26.869	2026-10-24 19:58:26.869
f78cd1db-5c79-4f6c-bc0a-1a9781d30ef8	7ac3b222-81bc-4051-b492-27cf0142b6a5	Standard	160	400	0	0	400	20	f	\N	\N	\N	2026-10-24 19:58:26.878	2026-10-24 19:58:26.878
52b40d89-deb1-4a6e-83e2-2788999bfb17	ee919d96-1dac-4543-964a-e0665d8e9dce	M	300	750	0	0	750	20	f	\N	\N	\N	2026-10-24 19:58:26.887	2026-10-24 19:58:26.887
93eaeb15-6f1e-441b-b2b9-41d49f9055ce	ee919d96-1dac-4543-964a-e0665d8e9dce	L	300	750	0	0	750	20	f	\N	\N	\N	2026-10-24 19:58:26.887	2026-10-24 19:58:26.887
24819bfd-73e9-4384-b024-1b7be96ec159	6a962db6-57a7-452c-b531-e85eb8124381	M	320	800	0	0	800	30	f	\N	\N	\N	2026-10-24 19:58:26.896	2026-10-24 19:58:26.896
6d580857-10b7-4f07-ad21-d8da45bf909c	6a962db6-57a7-452c-b531-e85eb8124381	L	320	800	0	0	800	30	f	\N	\N	\N	2026-10-24 19:58:26.896	2026-10-24 19:58:26.896
f79e3bc1-f451-40c8-a650-5bd6b2bfbb4f	4ed57174-1e05-4c61-b41f-2b3ea9c04474	36	950	2400	0	0	2400	15	f	\N	\N	\N	2026-10-24 20:03:56.332	2026-10-24 20:03:56.332
0f53db69-d1f8-485c-8a86-82e3d0c5d382	4ed57174-1e05-4c61-b41f-2b3ea9c04474	38	950	2400	0	0	2400	20	f	\N	\N	\N	2026-10-24 20:03:56.332	2026-10-24 20:03:56.332
af34d608-fa91-45cc-b2cc-f7640c1e8209	4ed57174-1e05-4c61-b41f-2b3ea9c04474	40	950	2400	0	0	2400	25	f	\N	\N	\N	2026-10-24 20:03:56.332	2026-10-24 20:03:56.332
4c50c5ad-b618-489a-9b05-8d72fe961410	4ed57174-1e05-4c61-b41f-2b3ea9c04474	42	950	2400	0	0	2400	20	f	\N	\N	\N	2026-10-24 20:03:56.332	2026-10-24 20:03:56.332
9a99a015-270d-4686-8812-d280bbda07fa	38069b07-6fd4-4a53-9d7c-ff6e52ebfdec	36	1000	2500	0	0	2500	12	f	\N	\N	\N	2026-10-24 20:03:56.361	2026-10-24 20:03:56.361
df235c80-e93f-40b5-9a2b-9e20153c9576	38069b07-6fd4-4a53-9d7c-ff6e52ebfdec	37	1000	2500	0	0	2500	15	f	\N	\N	\N	2026-10-24 20:03:56.361	2026-10-24 20:03:56.361
9da9add9-f8c9-4768-8839-c4225ece28bf	38069b07-6fd4-4a53-9d7c-ff6e52ebfdec	40	1000	2500	0	0	2500	22	f	\N	\N	\N	2026-10-24 20:03:56.361	2026-10-24 20:03:56.361
264081a6-a436-4ac5-9468-a1aae67786d5	38069b07-6fd4-4a53-9d7c-ff6e52ebfdec	42	1000	2500	0	0	2500	18	f	\N	\N	\N	2026-10-24 20:03:56.361	2026-10-24 20:03:56.361
837c416f-62c9-41a7-87b4-f2a12e4eb29e	cd777e93-c96c-4ef3-90d3-42c240452c79	36	880	2150	0	0	2150	15	f	\N	\N	\N	2026-10-24 20:03:56.38	2026-10-24 20:03:56.38
1aba6fa8-0391-41d3-9b6d-a9f05c0fcb92	cd777e93-c96c-4ef3-90d3-42c240452c79	37	880	2150	0	0	2150	15	f	\N	\N	\N	2026-10-24 20:03:56.38	2026-10-24 20:03:56.38
8eb44ea2-f5a8-47e8-a512-ff988b0fcea9	cd777e93-c96c-4ef3-90d3-42c240452c79	38	880	2150	0	0	2150	20	f	\N	\N	\N	2026-10-24 20:03:56.38	2026-10-24 20:03:56.38
eb33b0ce-9898-46f4-892a-333da5cfc017	cd777e93-c96c-4ef3-90d3-42c240452c79	40	880	2150	0	0	2150	25	f	\N	\N	\N	2026-10-24 20:03:56.38	2026-10-24 20:03:56.38
c85e8eeb-92f9-4525-a747-815fc20edc72	cd777e93-c96c-4ef3-90d3-42c240452c79	42	880	2150	0	0	2150	20	f	\N	\N	\N	2026-10-24 20:03:56.38	2026-10-24 20:03:56.38
3b26e227-5ade-4e75-9017-2af7d4d88229	577a4010-5a2b-405a-a8d2-4b066bcf4372	36	900	2200	0	0	2200	15	f	\N	\N	\N	2026-10-24 20:03:56.401	2026-10-24 20:03:56.401
8cd2a82e-2bca-4359-b39f-04f307338c2c	577a4010-5a2b-405a-a8d2-4b066bcf4372	37	900	2200	0	0	2200	18	f	\N	\N	\N	2026-10-24 20:03:56.401	2026-10-24 20:03:56.401
fdbe328d-9a7b-45a0-ac9d-3eaf6d14cdca	577a4010-5a2b-405a-a8d2-4b066bcf4372	38	900	2200	0	0	2200	20	f	\N	\N	\N	2026-10-24 20:03:56.401	2026-10-24 20:03:56.401
7167cc66-debd-4204-996e-dd90ebd17616	577a4010-5a2b-405a-a8d2-4b066bcf4372	40	900	2200	0	0	2200	30	f	\N	\N	\N	2026-10-24 20:03:56.401	2026-10-24 20:03:56.401
eeef860e-64c1-47d7-b031-65ac8637bdfb	577a4010-5a2b-405a-a8d2-4b066bcf4372	42	900	2200	0	0	2200	25	f	\N	\N	\N	2026-10-24 20:03:56.401	2026-10-24 20:03:56.401
eb9b5444-08fc-4908-9359-7e9d033a1294	28e5cb99-585c-4d50-a9aa-ca51f3770849	36	820	1990	0	0	1990	15	f	\N	\N	\N	2026-10-24 20:03:56.42	2026-10-24 20:03:56.42
d4eadca9-e8d8-462d-99e9-657cc40e1d8d	28e5cb99-585c-4d50-a9aa-ca51f3770849	37	820	1990	0	0	1990	15	f	\N	\N	\N	2026-10-24 20:03:56.42	2026-10-24 20:03:56.42
2576ab82-a7ba-40fe-b069-d9878ef90c83	28e5cb99-585c-4d50-a9aa-ca51f3770849	38	820	1990	0	0	1990	20	f	\N	\N	\N	2026-10-24 20:03:56.42	2026-10-24 20:03:56.42
f8e1a8e8-ad53-4b88-8752-90e5d0ed5d76	28e5cb99-585c-4d50-a9aa-ca51f3770849	40	820	1990	0	0	1990	25	f	\N	\N	\N	2026-10-24 20:03:56.42	2026-10-24 20:03:56.42
f93cb060-eb39-4c2d-b3a8-191823c3b8cc	28e5cb99-585c-4d50-a9aa-ca51f3770849	42	820	1990	0	0	1990	20	f	\N	\N	\N	2026-10-24 20:03:56.42	2026-10-24 20:03:56.42
5304a920-2e6a-4a91-9acc-43cccecfc146	bb146b31-8b60-43ed-a111-42ea9857c147	36	780	1850	0	0	1850	15	f	\N	\N	\N	2026-10-24 20:03:56.44	2026-10-24 20:03:56.44
47d40953-ac84-4c2e-bb18-b4eb71871ad7	bb146b31-8b60-43ed-a111-42ea9857c147	37	780	1850	0	0	1850	18	f	\N	\N	\N	2026-10-24 20:03:56.44	2026-10-24 20:03:56.44
4d75971f-054c-4f49-ba2f-9d503c359a43	bb146b31-8b60-43ed-a111-42ea9857c147	38	780	1850	0	0	1850	22	f	\N	\N	\N	2026-10-24 20:03:56.44	2026-10-24 20:03:56.44
36526470-2ed0-4cfa-81e0-7851022c91d8	bb146b31-8b60-43ed-a111-42ea9857c147	40	780	1850	0	0	1850	25	f	\N	\N	\N	2026-10-24 20:03:56.44	2026-10-24 20:03:56.44
dc487b3d-8054-4e06-a806-5adca4a8f49b	bb146b31-8b60-43ed-a111-42ea9857c147	42	780	1850	0	0	1850	20	f	\N	\N	\N	2026-10-24 20:03:56.44	2026-10-24 20:03:56.44
0fff2f9b-2f12-47ef-a082-2ea3db497f65	89df97a3-38e3-4c2f-ad60-744d1bf7268a	36	420	1050	0	0	1050	15	f	\N	\N	\N	2026-10-24 20:03:56.46	2026-10-24 20:03:56.46
600d6176-006e-467a-9f66-6f9e0025e56d	89df97a3-38e3-4c2f-ad60-744d1bf7268a	37	420	1050	0	0	1050	15	f	\N	\N	\N	2026-10-24 20:03:56.46	2026-10-24 20:03:56.46
d9533d76-78d7-4933-9c92-9e73dcebf28d	89df97a3-38e3-4c2f-ad60-744d1bf7268a	38	420	1050	0	0	1050	20	f	\N	\N	\N	2026-10-24 20:03:56.46	2026-10-24 20:03:56.46
5d44209e-21aa-421b-abeb-bbd77197b31a	89df97a3-38e3-4c2f-ad60-744d1bf7268a	40	420	1050	0	0	1050	25	f	\N	\N	\N	2026-10-24 20:03:56.46	2026-10-24 20:03:56.46
02e8e362-128b-4b7e-a3cf-f50e0d7ee2e6	4ed57174-1e05-4c61-b41f-2b3ea9c04474	37	950	2400	0	0	2400	14	f	\N	\N	\N	2026-10-24 20:03:56.332	2026-10-26 19:44:02.266
2cd63154-d90d-46e5-b60f-6383ba37fb8a	89df97a3-38e3-4c2f-ad60-744d1bf7268a	42	420	1050	0	0	1050	20	f	\N	\N	\N	2026-10-24 20:03:56.46	2026-10-24 20:03:56.46
7bd1164b-7109-4636-adb8-c47fc24fb4e4	0c9c47a1-7ad0-44d8-84e4-4749ed749ce8	36	450	1100	0	0	1100	12	f	\N	\N	\N	2026-10-24 20:03:56.479	2026-10-24 20:03:56.479
8ce10d2c-e788-45d6-8539-d332434aa51c	0c9c47a1-7ad0-44d8-84e4-4749ed749ce8	37	450	1100	0	0	1100	15	f	\N	\N	\N	2026-10-24 20:03:56.479	2026-10-24 20:03:56.479
a90195ce-070f-4372-a093-b73b25709985	0c9c47a1-7ad0-44d8-84e4-4749ed749ce8	38	450	1100	0	0	1100	18	f	\N	\N	\N	2026-10-24 20:03:56.479	2026-10-24 20:03:56.479
d0e4ed21-d28d-46dc-9496-c30b273bd2f0	0c9c47a1-7ad0-44d8-84e4-4749ed749ce8	40	450	1100	0	0	1100	22	f	\N	\N	\N	2026-10-24 20:03:56.479	2026-10-24 20:03:56.479
5764aa42-314c-4689-9348-b18976cc4cd1	0c9c47a1-7ad0-44d8-84e4-4749ed749ce8	42	450	1100	0	0	1100	18	f	\N	\N	\N	2026-10-24 20:03:56.479	2026-10-24 20:03:56.479
48415524-be60-4c99-b665-904f05c87023	01202189-9e12-43b5-b326-d2324501ed7e	M	480	1200	10	120	1080	20	f	\N	\N	\N	2026-10-24 20:03:56.498	2026-10-24 20:03:56.498
233abaae-a7a1-4e37-97a6-533831381561	01202189-9e12-43b5-b326-d2324501ed7e	XL	480	1200	10	120	1080	20	f	\N	\N	\N	2026-10-24 20:03:56.498	2026-10-24 20:03:56.498
439b2143-8693-435f-9688-1f977474e3c3	01202189-9e12-43b5-b326-d2324501ed7e	XXL	480	1200	10	120	1080	15	f	\N	\N	\N	2026-10-24 20:03:56.498	2026-10-24 20:03:56.498
80693a2b-5931-4263-93bb-5ac560869c0b	f879d781-a80d-49db-a89f-5696b0cb9e8b	M	500	1300	10	130	1170	18	f	\N	\N	\N	2026-10-24 20:03:56.515	2026-10-24 20:03:56.515
8712100a-b974-4816-98ca-2efb019254b3	f879d781-a80d-49db-a89f-5696b0cb9e8b	XXL	500	1300	10	130	1170	15	f	\N	\N	\N	2026-10-24 20:03:56.515	2026-10-24 20:03:56.515
dd62feb9-6b1d-402a-951c-820ba926db94	f3bb6102-568b-4ca1-b0e5-e4288083c0a9	M	400	990	10	99	891	25	f	\N	\N	\N	2026-10-24 20:03:56.531	2026-10-24 20:03:56.531
6657b656-bd62-43cb-a1c9-2ece32d7f680	f3bb6102-568b-4ca1-b0e5-e4288083c0a9	XL	400	990	10	99	891	20	f	\N	\N	\N	2026-10-24 20:03:56.531	2026-10-24 20:03:56.531
7da39a57-1dba-4478-bc33-e87388be9802	f3bb6102-568b-4ca1-b0e5-e4288083c0a9	XXL	400	990	10	99	891	15	f	\N	\N	\N	2026-10-24 20:03:56.531	2026-10-24 20:03:56.531
efd45d82-db86-4432-b160-3074c69b2ee6	76572a8c-9d93-4f7e-9e4b-0b396ef9a742	M	390	980	10	98	882	20	f	\N	\N	\N	2026-10-24 20:03:56.547	2026-10-24 20:03:56.547
bea1e50b-e49e-4d42-ad51-a8d22bf57332	76572a8c-9d93-4f7e-9e4b-0b396ef9a742	L	390	980	10	98	882	28	f	\N	\N	\N	2026-10-24 20:03:56.547	2026-10-24 20:03:56.547
36ffc44d-5e80-45b9-b1eb-e80f384961b6	76572a8c-9d93-4f7e-9e4b-0b396ef9a742	XL	390	980	10	98	882	22	f	\N	\N	\N	2026-10-24 20:03:56.547	2026-10-24 20:03:56.547
3154af95-25e2-44c7-a096-2f8080c4f4d2	76572a8c-9d93-4f7e-9e4b-0b396ef9a742	XXL	390	980	10	98	882	15	f	\N	\N	\N	2026-10-24 20:03:56.547	2026-10-24 20:03:56.547
99287473-3689-47cc-a3ad-0459f2ce2964	8aa29284-2997-4130-bc55-a213eb620567	L	520	1350	0	0	1350	22	f	\N	\N	\N	2026-10-24 20:03:56.569	2026-10-24 20:03:56.569
e411c430-e55f-4eca-88cd-4022638b1183	8aa29284-2997-4130-bc55-a213eb620567	XL	520	1350	0	0	1350	20	f	\N	\N	\N	2026-10-24 20:03:56.569	2026-10-24 20:03:56.569
9de2bce3-5e09-4dfa-ab17-d7cc8e3a25c0	8aa29284-2997-4130-bc55-a213eb620567	XXL	520	1350	0	0	1350	12	f	\N	\N	\N	2026-10-24 20:03:56.569	2026-10-24 20:03:56.569
121bb6a0-afb4-4260-a6f1-a6ac2c3de2bb	00dcbfd7-09e0-444d-8914-9a5c26b4ac8f	M	440	1100	0	0	1100	20	f	\N	\N	\N	2026-10-24 20:03:56.586	2026-10-24 20:03:56.586
9c449cb0-ae96-4269-9c0b-52957c42f9d9	00dcbfd7-09e0-444d-8914-9a5c26b4ac8f	L	440	1100	0	0	1100	25	f	\N	\N	\N	2026-10-24 20:03:56.586	2026-10-24 20:03:56.586
15876744-36ff-4c67-b14e-dda7b20d26e7	00dcbfd7-09e0-444d-8914-9a5c26b4ac8f	XL	440	1100	0	0	1100	20	f	\N	\N	\N	2026-10-24 20:03:56.586	2026-10-24 20:03:56.586
e96a2b43-5540-4098-bfa8-c9fb5f84c14a	00dcbfd7-09e0-444d-8914-9a5c26b4ac8f	XXL	440	1100	0	0	1100	10	f	\N	\N	\N	2026-10-24 20:03:56.586	2026-10-24 20:03:56.586
5e0c0535-f93a-4f59-ac75-d370555e1a82	d33c9a0f-7907-4cab-a8a2-d6e8bb27dd6a	M	410	1050	0	0	1050	22	f	\N	\N	\N	2026-10-24 20:03:56.602	2026-10-24 20:03:56.602
5e7ed350-b18b-40f3-b75e-cdfd965380f7	d33c9a0f-7907-4cab-a8a2-d6e8bb27dd6a	L	410	1050	0	0	1050	30	f	\N	\N	\N	2026-10-24 20:03:56.602	2026-10-24 20:03:56.602
b465b1ad-14de-4ce8-b9fe-9713cbbc26ee	d33c9a0f-7907-4cab-a8a2-d6e8bb27dd6a	XL	410	1050	0	0	1050	25	f	\N	\N	\N	2026-10-24 20:03:56.602	2026-10-24 20:03:56.602
c8be49a7-6e4b-4754-bfde-4224e06bc540	d33c9a0f-7907-4cab-a8a2-d6e8bb27dd6a	XXL	410	1050	0	0	1050	18	f	\N	\N	\N	2026-10-24 20:03:56.602	2026-10-24 20:03:56.602
f315a250-fedf-4d9a-8139-b7cafd6325fa	7901703c-e519-4da1-a4b3-86939d3cfe3e	M	600	1550	0	0	1550	15	f	\N	\N	\N	2026-10-24 20:03:56.62	2026-10-24 20:03:56.62
db7ca5dd-ad15-41bb-a75c-d07b614f8846	7901703c-e519-4da1-a4b3-86939d3cfe3e	L	600	1550	0	0	1550	20	f	\N	\N	\N	2026-10-24 20:03:56.62	2026-10-24 20:03:56.62
38c085f8-e947-4bc0-923d-54730e063796	7901703c-e519-4da1-a4b3-86939d3cfe3e	XL	600	1550	0	0	1550	15	f	\N	\N	\N	2026-10-24 20:03:56.62	2026-10-24 20:03:56.62
541fb5f6-2806-4c37-93e2-e7ec38c7294e	7901703c-e519-4da1-a4b3-86939d3cfe3e	XXL	600	1550	0	0	1550	10	f	\N	\N	\N	2026-10-24 20:03:56.62	2026-10-24 20:03:56.62
edce77be-37a7-4a28-b9e0-5c061c57009e	2099a22c-4955-44c4-af6b-6616e133247e	M	800	2100	0	0	2100	15	f	\N	\N	\N	2026-10-24 20:03:56.636	2026-10-24 20:03:56.636
2ecf6195-e367-45e3-8c51-f2e226087d92	2099a22c-4955-44c4-af6b-6616e133247e	L	800	2100	0	0	2100	18	f	\N	\N	\N	2026-10-24 20:03:56.636	2026-10-24 20:03:56.636
15ca38ab-5c91-4c21-aae1-338582766c23	2099a22c-4955-44c4-af6b-6616e133247e	XXL	800	2100	0	0	2100	8	f	\N	\N	\N	2026-10-24 20:03:56.636	2026-10-24 20:03:56.636
034a6c83-7728-4b24-b483-232fc0788049	5f5cc789-3c3d-4465-996d-cdd8fd8b90bb	M	680	1700	0	0	1700	15	f	\N	\N	\N	2026-10-24 20:03:56.653	2026-10-24 20:03:56.653
eb34a16b-045f-4548-84a9-e4b3374f51a6	2099a22c-4955-44c4-af6b-6616e133247e	XL	800	2100	0	0	2100	11	f	\N	\N	\N	2026-10-24 20:03:56.636	2026-10-25 20:40:43.502
4d861a6e-0bea-43d0-a2cc-7a24be4d694c	f3bb6102-568b-4ca1-b0e5-e4288083c0a9	L	400	990	10	99	891	29	f	\N	\N	\N	2026-10-24 20:03:56.531	2026-11-01 17:49:50.595
3e700e92-fe07-4a5e-a4d4-1d0cd326dca3	01202189-9e12-43b5-b326-d2324501ed7e	L	480	1200	10	120	1080	24	f	\N	\N	\N	2026-10-24 20:03:56.498	2026-11-04 09:17:14.627
a91354a5-c246-47a2-bb9e-cb1156cdff6f	5f5cc789-3c3d-4465-996d-cdd8fd8b90bb	L	680	1700	0	0	1700	20	f	\N	\N	\N	2026-10-24 20:03:56.653	2026-10-24 20:03:56.653
d8384008-9ac9-4195-9d4a-29a9ee4778e8	5f5cc789-3c3d-4465-996d-cdd8fd8b90bb	XL	680	1700	0	0	1700	15	f	\N	\N	\N	2026-10-24 20:03:56.653	2026-10-24 20:03:56.653
ec1724da-adf0-4363-9a5c-f813a1bfbe90	5f5cc789-3c3d-4465-996d-cdd8fd8b90bb	XXL	680	1700	0	0	1700	10	f	\N	\N	\N	2026-10-24 20:03:56.653	2026-10-24 20:03:56.653
a5448c48-0f63-4a9b-b81b-98ed942eae55	b15ba6e3-7ad4-437a-8f23-5db2ce4c7f3e	M	720	1800	0	0	1800	15	f	\N	\N	\N	2026-10-24 20:03:56.696	2026-10-24 20:03:56.696
e4accf54-a704-49db-b152-61bd0e411195	b15ba6e3-7ad4-437a-8f23-5db2ce4c7f3e	XL	720	1800	0	0	1800	18	f	\N	\N	\N	2026-10-24 20:03:56.696	2026-10-24 20:03:56.696
932d039f-a6e7-4395-b994-dce64c5c65cf	b15ba6e3-7ad4-437a-8f23-5db2ce4c7f3e	XXL	720	1800	0	0	1800	12	f	\N	\N	\N	2026-10-24 20:03:56.696	2026-10-24 20:03:56.696
0ff04a82-161a-4384-8879-e096bb9a3dfa	fcd96dd4-e631-46bd-b5e8-ff564ce5dea7	L	750	1900	0	0	1900	20	f	\N	\N	\N	2026-10-24 20:03:56.715	2026-10-24 20:03:56.715
381632cf-892e-474a-8925-0448e6e26675	fcd96dd4-e631-46bd-b5e8-ff564ce5dea7	XL	750	1900	0	0	1900	15	f	\N	\N	\N	2026-10-24 20:03:56.715	2026-10-24 20:03:56.715
543bcd6f-7a34-4709-a271-e8a094bd594c	fcd96dd4-e631-46bd-b5e8-ff564ce5dea7	XXL	750	1900	0	0	1900	10	f	\N	\N	\N	2026-10-24 20:03:56.715	2026-10-24 20:03:56.715
ed613e4f-9bf7-4711-ae36-65669f9f8769	bfa9b3b5-38cb-4d63-8501-694125f75f63	L	620	1550	10	155	1395	25	f	\N	\N	\N	2026-10-24 20:03:56.735	2026-10-24 20:03:56.735
fd42b521-d1d0-454b-bbd1-64a187c70dd7	bfa9b3b5-38cb-4d63-8501-694125f75f63	XL	620	1550	10	155	1395	20	f	\N	\N	\N	2026-10-24 20:03:56.735	2026-10-24 20:03:56.735
9edff9d0-e0f7-4b33-8ba7-d9dad94cd93e	bfa9b3b5-38cb-4d63-8501-694125f75f63	XXL	620	1550	10	155	1395	15	f	\N	\N	\N	2026-10-24 20:03:56.735	2026-10-24 20:03:56.735
0e96cf2d-2f20-49e3-bf1b-4c6cea7cfbee	fb08a2dc-2287-4702-b88c-4a60ccea278c	XL	650	1600	10	160	1440	20	f	\N	\N	\N	2026-10-24 20:03:56.754	2026-10-24 20:03:56.754
4dbb10cc-5a0d-4900-9c97-f0929fca400e	b6bcf5c0-6006-491b-bdbe-e637e0e8fcdc	M	630	1580	10	158	1422	18	f	\N	\N	\N	2026-10-24 20:03:56.771	2026-10-24 20:03:56.771
38f8fc7d-ebd5-444e-928d-e0ccaa5ea6aa	b6bcf5c0-6006-491b-bdbe-e637e0e8fcdc	L	630	1580	10	158	1422	25	f	\N	\N	\N	2026-10-24 20:03:56.771	2026-10-24 20:03:56.771
36960f4f-09c3-4049-9736-2a6107687cfc	b6bcf5c0-6006-491b-bdbe-e637e0e8fcdc	XL	630	1580	10	158	1422	22	f	\N	\N	\N	2026-10-24 20:03:56.771	2026-10-24 20:03:56.771
26d919b1-22d8-4ff5-a6c5-d21ef56fc11d	b6bcf5c0-6006-491b-bdbe-e637e0e8fcdc	XXL	630	1580	10	158	1422	15	f	\N	\N	\N	2026-10-24 20:03:56.771	2026-10-24 20:03:56.771
ade61178-2e5e-4329-b152-32f9a36bc7ef	62c78000-e142-448a-a870-3e74bc7fabfa	M	750	1900	10	190	1710	25	f	\N	\N	\N	2026-10-24 20:03:56.787	2026-10-24 20:03:56.787
af55c0ae-da57-4d63-be3c-0b271858d4b5	62c78000-e142-448a-a870-3e74bc7fabfa	L	750	1900	10	190	1710	30	f	\N	\N	\N	2026-10-24 20:03:56.787	2026-10-24 20:03:56.787
3b31738d-ed2b-4bbf-9b3f-7809025d421f	62c78000-e142-448a-a870-3e74bc7fabfa	XXL	750	1900	10	190	1710	15	f	\N	\N	\N	2026-10-24 20:03:56.787	2026-10-24 20:03:56.787
c4b5c99f-7aa5-42a6-a5ad-609365982b56	570a2ef9-68b3-48a1-9eec-e0a1b7613714	XL	720	1850	10	185	1665	25	f	\N	\N	\N	2026-10-24 20:03:56.804	2026-10-24 20:03:56.804
d1ee974a-99c7-422d-9dbe-c14398235010	570a2ef9-68b3-48a1-9eec-e0a1b7613714	XXL	720	1850	10	185	1665	15	f	\N	\N	\N	2026-10-24 20:03:56.804	2026-10-24 20:03:56.804
7ee47940-b1a1-4fe7-8a11-a6cf0fa31ed0	a79405f9-9b42-4c8e-8d97-6e6b28a7be3a	XXL	380	920	10	92	828	20	f	\N	\N	\N	2026-10-24 20:03:56.82	2026-10-24 20:03:56.82
66421e20-6df7-481a-9c35-852be0d386e1	247c17ed-3853-462e-b4a2-1c4f4fbfce35	XL	360	880	10	88	792	25	f	\N	\N	\N	2026-10-24 20:03:56.836	2026-10-24 20:03:56.836
db80614a-a070-4850-b0c1-304f4167bd11	247c17ed-3853-462e-b4a2-1c4f4fbfce35	XXL	360	880	10	88	792	15	f	\N	\N	\N	2026-10-24 20:03:56.836	2026-10-24 20:03:56.836
90b2efa1-086d-4ffc-9576-08d9ce541a97	fb08a2dc-2287-4702-b88c-4a60ccea278c	L	650	1600	10	160	1440	24	f	\N	\N	\N	2026-10-24 20:03:56.754	2026-10-25 19:53:59.445
aa21a523-c202-44e5-91cf-415469d36a33	fb08a2dc-2287-4702-b88c-4a60ccea278c	M	650	1600	10	160	1440	17	f	\N	\N	\N	2026-10-24 20:03:56.754	2026-10-26 18:52:29.518
1b9c18da-84e6-47c4-b10a-dbfc73bd150a	a79405f9-9b42-4c8e-8d97-6e6b28a7be3a	L	380	920	10	92	828	34	f	\N	\N	\N	2026-10-24 20:03:56.82	2026-10-26 18:52:29.518
cfe9ee14-f468-4e94-b6cd-f5f185031ed6	bfa9b3b5-38cb-4d63-8501-694125f75f63	M	620	1550	10	155	1395	19	f	\N	\N	\N	2026-10-24 20:03:56.735	2026-10-26 19:44:02.266
f3e3067d-4fd1-40d1-b6cb-a1f505d9eddf	1a4f4714-447c-449d-b68f-4a339d535f5c	L	390	950	10	95	855	26	f	\N	\N	\N	2026-10-24 20:03:56.852	2026-10-28 15:41:48.258
8bbbe703-bd29-47ee-9f58-3f07c7bd844c	570a2ef9-68b3-48a1-9eec-e0a1b7613714	M	720	1850	10	185	1665	21	f	\N	\N	\N	2026-10-24 20:03:56.804	2026-10-28 15:41:48.258
4c49f554-2812-4add-9851-ea97cb3185d7	b15ba6e3-7ad4-437a-8f23-5db2ce4c7f3e	L	720	1800	0	0	1800	18	f	\N	\N	\N	2026-10-24 20:03:56.696	2026-10-28 19:21:36.511
e0ecc281-be44-4653-94e4-d2936e1712b7	570a2ef9-68b3-48a1-9eec-e0a1b7613714	L	720	1850	10	185	1665	29	f	\N	\N	\N	2026-10-24 20:03:56.804	2026-11-01 17:49:50.595
abad65b6-e6d5-426f-85fc-8ebf18553f15	fcd96dd4-e631-46bd-b5e8-ff564ce5dea7	M	750	1900	0	0	1900	12	f	\N	\N	\N	2026-10-24 20:03:56.715	2026-11-04 09:17:14.627
599dda06-a39b-4b52-9726-896890f14880	fb08a2dc-2287-4702-b88c-4a60ccea278c	XXL	650	1600	10	160	1440	14	f	\N	\N	\N	2026-10-24 20:03:56.754	2026-11-04 09:17:14.627
cf8423aa-5deb-485a-a298-5fad764f0c7e	62c78000-e142-448a-a870-3e74bc7fabfa	XL	750	1900	10	190	1710	14	f	\N	\N	\N	2026-10-24 20:03:56.787	2026-11-04 09:17:14.627
df730f76-5d2b-4a47-8588-673bd3c5f650	a79405f9-9b42-4c8e-8d97-6e6b28a7be3a	XL	380	920	10	92	828	24	f	\N	\N	\N	2026-10-24 20:03:56.82	2026-11-04 09:17:14.627
4b084cea-ac57-49bf-a1ff-84c35d89c943	3657f403-d21f-414d-8fe0-c8535b8ebdca	M	410	990	10	99	891	20	f	\N	\N	\N	2026-10-24 20:03:56.869	2026-10-24 20:03:56.869
0cfdcd4a-b93f-43bb-b886-071e5acbf9d3	3657f403-d21f-414d-8fe0-c8535b8ebdca	XXL	410	990	10	99	891	18	f	\N	\N	\N	2026-10-24 20:03:56.869	2026-10-24 20:03:56.869
945bbbde-0e9a-4dc9-8750-36c7c7198ac8	c530f1c8-97d7-4573-8ecf-62c63593a252	XXL	510	1320	10	132	1188	15	f	\N	\N	\N	2026-10-24 20:03:56.885	2026-10-24 20:03:56.885
b410ca9f-e127-414f-b5d6-90c46a29ae8f	c530f1c8-97d7-4573-8ecf-62c63593a252	XL	510	1320	10	132	1188	19	f	\N	\N	\N	2026-10-24 20:03:56.885	2026-10-25 19:49:45.515
2b0d0b4f-16bc-4ffa-bc0d-4455fe9f45a6	1a4f4714-447c-449d-b68f-4a339d535f5c	XL	390	950	10	95	855	20	f	\N	\N	\N	2026-10-24 20:03:56.852	2026-10-25 19:53:59.445
778cea45-f760-4762-bbdb-659fde290077	f879d781-a80d-49db-a89f-5696b0cb9e8b	XL	500	1300	10	130	1170	19	f	\N	\N	\N	2026-10-24 20:03:56.515	2026-10-25 19:53:59.445
d69edb49-e801-411e-be05-b6a71fcd8dec	a79405f9-9b42-4c8e-8d97-6e6b28a7be3a	M	380	920	10	92	828	24	f	\N	\N	\N	2026-10-24 20:03:56.82	2026-10-25 19:55:30.829
3c86eeec-7656-47a9-be24-c84385d22b2d	ef7e970f-a415-45f4-b98b-0aa741925ea3	40	950	2300	0	0	2300	14	f	\N	\N	\N	2026-10-24 19:58:26.726	2026-10-25 20:39:18.082
8cf78a75-6ecf-4869-ab0a-078277265dcf	9d7c598a-dbdb-4ab2-bf06-277e66287d68	38	250	650	0	0	650	34	f	\N	\N	\N	2026-10-24 19:58:26.754	2026-10-25 20:39:18.082
8b8eae1b-0863-469c-acdb-61873e0ebd95	38069b07-6fd4-4a53-9d7c-ff6e52ebfdec	38	1000	2500	0	0	2500	17	f	\N	\N	\N	2026-10-24 20:03:56.361	2026-10-26 07:11:59.313
29660394-f905-45d5-ba5b-e89421e201af	1a4f4714-447c-449d-b68f-4a339d535f5c	M	390	950	10	95	855	19	f	\N	\N	\N	2026-10-24 20:03:56.852	2026-10-26 18:52:29.518
f0c7d7e0-864a-483d-8b2a-dac03bd842cc	247c17ed-3853-462e-b4a2-1c4f4fbfce35	M	360	880	10	88	792	19	f	\N	\N	\N	2026-10-24 20:03:56.836	2026-10-26 18:52:29.518
b6f61d2e-0f9f-43b0-b598-e12b7cb7b8c3	c530f1c8-97d7-4573-8ecf-62c63593a252	M	510	1320	10	132	1188	19	f	\N	\N	\N	2026-10-24 20:03:56.885	2026-10-29 16:03:03.776
ec2c1062-f41c-467b-9acd-e5b25b3c4cf2	3657f403-d21f-414d-8fe0-c8535b8ebdca	L	410	990	10	99	891	28	f	\N	\N	\N	2026-10-24 20:03:56.869	2026-11-01 17:49:50.595
17d15409-3f51-465f-aab0-5b4af77336e3	3657f403-d21f-414d-8fe0-c8535b8ebdca	XL	410	990	10	99	891	23	f	\N	\N	\N	2026-10-24 20:03:56.869	2026-11-04 09:17:14.627
98937cb3-588a-4f71-bef6-90cbdf14d86e	c530f1c8-97d7-4573-8ecf-62c63593a252	L	510	1320	10	132	1188	23	f	\N	\N	\N	2026-10-24 20:03:56.885	2026-11-04 09:17:14.627
61997b81-81db-4a50-987e-c24e9504c080	1a4f4714-447c-449d-b68f-4a339d535f5c	XXL	390	950	10	95	855	11	f	\N	\N	\N	2026-10-24 20:03:56.852	2026-11-04 09:17:14.627
1016448f-3831-46ae-9ae0-37c69a281cad	247c17ed-3853-462e-b4a2-1c4f4fbfce35	L	360	880	10	88	792	29	f	\N	\N	\N	2026-10-24 20:03:56.836	2026-11-04 09:17:14.627
de488e00-792d-4a07-81b2-daeed8d2e5ba	f879d781-a80d-49db-a89f-5696b0cb9e8b	L	500	1300	10	130	1170	21	f	\N	\N	\N	2026-10-24 20:03:56.515	2026-11-04 09:17:14.627
34b2aeb3-0829-48d5-94b4-b5cf7fa15b8c	8aa29284-2997-4130-bc55-a213eb620567	M	520	1350	0	0	1350	17	f	\N	\N	\N	2026-10-24 20:03:56.569	2026-11-04 09:17:14.627
\.


--
-- Data for Name: ProductImage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."ProductImage" (id, "productId", image, "isDeleted", "createdBy", "updatedBy", "deletedBy", "createdAt", "updatedAt") FROM stdin;
54813213-2778-466d-9b7e-a5e3cf184cb8	9c4dfc17-0be9-4abd-ba0f-0dfd49aeb0cf	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792834056/product/stk2i74thvq2qpon6nny.webp	f	\N	\N	\N	2026-10-24 09:27:38.324	2026-10-24 09:27:38.324
f10f10a0-8bb2-4a54-8540-53245eae0f15	9c4dfc17-0be9-4abd-ba0f-0dfd49aeb0cf	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792834057/product/gl6krt406b1rfata3v5n.webp	f	\N	\N	\N	2026-10-24 09:27:38.324	2026-10-24 09:27:38.324
aaeda1c6-a8b1-4c29-9e13-3b8c4b88fe55	9c4dfc17-0be9-4abd-ba0f-0dfd49aeb0cf	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792834057/product/czis9zmdw8ngr3wb98of.webp	f	\N	\N	\N	2026-10-24 09:27:38.324	2026-10-24 09:27:38.324
821fe190-2c4e-4aba-b959-97aa56822198	9c4dfc17-0be9-4abd-ba0f-0dfd49aeb0cf	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792834057/product/rprswmttgt0mpqbuvkdv.webp	f	\N	\N	\N	2026-10-24 09:27:38.324	2026-10-24 09:27:38.324
4d9dff74-6c71-4a63-9c0a-fa29b1c4c3d5	c530f1c8-97d7-4573-8ecf-62c63593a252	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792872457/product/jfhsiabtdgwtgotc9bnp.jpg	f	\N	\N	\N	2026-10-24 20:07:38.28	2026-10-24 20:07:38.28
db5a32e2-5e9f-4393-9f55-a2cfbb55a3e4	c530f1c8-97d7-4573-8ecf-62c63593a252	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792872556/product/zg4tg8n6uioz1ozxdu1e.webp	f	\N	\N	\N	2026-10-24 20:09:17.072	2026-10-24 20:09:17.072
bbf80770-5ed0-4904-bef2-bdcd826b2abf	3657f403-d21f-414d-8fe0-c8535b8ebdca	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792872638/product/mcszxc3ivxpieuv4tpfa.jpg	f	\N	\N	\N	2026-10-24 20:10:38.573	2026-10-24 20:10:38.573
6528b282-b66b-458d-a852-f1fc9931b70c	3657f403-d21f-414d-8fe0-c8535b8ebdca	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792872651/product/juhkqkghucsjmommqcdz.jpg	f	\N	\N	\N	2026-10-24 20:10:52.194	2026-10-24 20:10:52.194
6b274f79-a81b-43a3-a701-67e9826580b7	1a4f4714-447c-449d-b68f-4a339d535f5c	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792872681/product/irnfyneufpdxlce1l9u4.jpg	f	\N	\N	\N	2026-10-24 20:11:21.626	2026-10-24 20:11:21.626
13bb1ac8-6bff-4091-b443-8d856930ebd8	1a4f4714-447c-449d-b68f-4a339d535f5c	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792872687/product/vpysupz4dowwtzngcqnm.jpg	f	\N	\N	\N	2026-10-24 20:11:28.274	2026-10-24 20:11:28.274
31414c09-0eee-428a-ae40-bd3644a38c4a	1a4f4714-447c-449d-b68f-4a339d535f5c	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792872709/product/q9fq5gjkshybcab3z2el.jpg	f	\N	\N	\N	2026-10-24 20:11:49.934	2026-10-24 20:11:49.934
77ad5f72-6b0d-4c0a-954c-0ef5ca3a6fe8	247c17ed-3853-462e-b4a2-1c4f4fbfce35	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792872740/product/ebqtdw4qdnn8cqc2vlez.jpg	f	\N	\N	\N	2026-10-24 20:12:20.834	2026-10-24 20:12:20.834
7aeff2c1-c139-41aa-b0f4-ca3cca0fb37c	247c17ed-3853-462e-b4a2-1c4f4fbfce35	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792872747/product/b53lohqgcrbskjasm3pv.jpg	f	\N	\N	\N	2026-10-24 20:12:27.66	2026-10-24 20:12:27.66
c2e17c61-75df-4200-b13e-7bee054bef69	247c17ed-3853-462e-b4a2-1c4f4fbfce35	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792872755/product/uedcm9hing4ocoo0jtlj.jpg	f	\N	\N	\N	2026-10-24 20:12:36.039	2026-10-24 20:12:36.039
de5c3bdc-b466-4939-aad4-35154a293067	247c17ed-3853-462e-b4a2-1c4f4fbfce35	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792872766/product/hmhjdyafu5fmr5ssfdti.jpg	f	\N	\N	\N	2026-10-24 20:12:46.586	2026-10-24 20:12:46.586
2321d533-f2e1-4d30-929e-83b35eccac73	a79405f9-9b42-4c8e-8d97-6e6b28a7be3a	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792872786/product/z7utyczkbzoir0gusbc4.jpg	f	\N	\N	\N	2026-10-24 20:13:07.326	2026-10-24 20:13:07.326
28bd51c9-0e29-43dc-a0ae-970775dd70d0	a79405f9-9b42-4c8e-8d97-6e6b28a7be3a	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792872796/product/hp7f4dmgicexwx5oz9zg.jpg	f	\N	\N	\N	2026-10-24 20:13:16.58	2026-10-24 20:13:16.58
98416173-beb5-43e9-bbd4-29a9cb3cff36	a79405f9-9b42-4c8e-8d97-6e6b28a7be3a	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792872802/product/mcqyufnajwfaevpzk3dt.jpg	f	\N	\N	\N	2026-10-24 20:13:22.633	2026-10-24 20:13:22.633
2df4a4b7-3e3f-45a8-9f73-4c4f3d148278	570a2ef9-68b3-48a1-9eec-e0a1b7613714	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955449/product/rj38lxwyzdjppmsm7wuy.jpg	f	\N	\N	\N	2026-10-25 19:10:50.393	2026-10-25 19:10:50.393
f079d27d-ddac-45d7-8b1e-2fd925d5752a	570a2ef9-68b3-48a1-9eec-e0a1b7613714	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955465/product/qo9sn1xfpz5dkt7u8ztc.jpg	f	\N	\N	\N	2026-10-25 19:11:05.78	2026-10-25 19:11:05.78
0c52e48a-ed74-4830-8979-b75b93d1571c	570a2ef9-68b3-48a1-9eec-e0a1b7613714	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955476/product/jlohrkrg1m080af1axiw.jpg	f	\N	\N	\N	2026-10-25 19:11:16.38	2026-10-25 19:11:16.38
e451151f-bf55-4735-9543-faa7c0e4b47f	62c78000-e142-448a-a870-3e74bc7fabfa	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955492/product/zolfopz2gqjnnyf0gadp.jpg	f	\N	\N	\N	2026-10-25 19:11:32.838	2026-10-25 19:11:32.838
885ea9f4-d873-4618-99ce-f43010081fb1	62c78000-e142-448a-a870-3e74bc7fabfa	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955498/product/dkrukryw0qt8gmvbab9g.jpg	f	\N	\N	\N	2026-10-25 19:11:39.277	2026-10-25 19:11:39.277
54bdc371-c686-4703-8e02-7bdd77c1e550	62c78000-e142-448a-a870-3e74bc7fabfa	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955504/product/icakousaqk0mhg1ptdr8.jpg	f	\N	\N	\N	2026-10-25 19:11:45.096	2026-10-25 19:11:45.096
0837a42f-6a52-4882-951c-0c52b967e24a	b6bcf5c0-6006-491b-bdbe-e637e0e8fcdc	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955527/product/mdnr1ctdqr1c0cq7gbwc.jpg	f	\N	\N	\N	2026-10-25 19:12:08.209	2026-10-25 19:12:08.209
da67a3a4-3bc7-4355-b1ba-37f258ee149d	b6bcf5c0-6006-491b-bdbe-e637e0e8fcdc	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955535/product/mxb0bvl8thpki6uxbjom.jpg	f	\N	\N	\N	2026-10-25 19:12:16.189	2026-10-25 19:12:16.189
57985666-10ac-4127-a04b-33a60286e033	fb08a2dc-2287-4702-b88c-4a60ccea278c	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955556/product/vynnvcfcvr2m42ehqyi3.jpg	f	\N	\N	\N	2026-10-25 19:12:37.038	2026-10-25 19:12:37.038
6f262639-a9e8-48a3-bf3c-90895bbdcda2	fb08a2dc-2287-4702-b88c-4a60ccea278c	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955569/product/jftfv87rraxskwfm8z8s.jpg	f	\N	\N	\N	2026-10-25 19:12:49.646	2026-10-25 19:12:49.646
5843bfe1-f3ed-4433-99b2-cb8326da23b2	fb08a2dc-2287-4702-b88c-4a60ccea278c	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955577/product/nu3pexxbzyunbprxv0qc.jpg	f	\N	\N	\N	2026-10-25 19:12:58.29	2026-10-25 19:12:58.29
8e064fb0-01e6-49c6-b966-18ccc9a639bb	bfa9b3b5-38cb-4d63-8501-694125f75f63	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955590/product/htgcpyyllxozqndyac3x.jpg	f	\N	\N	\N	2026-10-25 19:13:11.062	2026-10-25 19:13:11.062
58dd34e8-079d-4a09-99aa-3375abc39b35	fcd96dd4-e631-46bd-b5e8-ff564ce5dea7	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955623/product/x99yvs0rvnp1l2ewjzze.jpg	f	\N	\N	\N	2026-10-25 19:13:44.089	2026-10-25 19:13:44.089
0d6dc98c-bb6a-41c5-addd-ca980bf8a65e	fcd96dd4-e631-46bd-b5e8-ff564ce5dea7	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955630/product/yajde5iuyjn1pzpcf6qq.jpg	f	\N	\N	\N	2026-10-25 19:13:50.919	2026-10-25 19:13:50.919
dd9edc94-8a0c-457b-a997-b2f283f6bce0	b15ba6e3-7ad4-437a-8f23-5db2ce4c7f3e	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955649/product/eybkredh5mddc41qnmeo.jpg	f	\N	\N	\N	2026-10-25 19:14:10.004	2026-10-25 19:14:10.004
d77a0817-4ad1-4f49-b4bb-4a160b438530	b15ba6e3-7ad4-437a-8f23-5db2ce4c7f3e	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955658/product/xoscewfwz7ec3hp6vzz6.jpg	f	\N	\N	\N	2026-10-25 19:14:19.014	2026-10-25 19:14:19.014
abc95c3a-faea-4231-a1d7-de66bf6ae608	b15ba6e3-7ad4-437a-8f23-5db2ce4c7f3e	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955667/product/hxdgzih2gloypqhq5d8j.jpg	f	\N	\N	\N	2026-10-25 19:14:27.522	2026-10-25 19:14:27.522
c7f5105c-f6f6-40c1-b5b9-e9b8298605ed	b15ba6e3-7ad4-437a-8f23-5db2ce4c7f3e	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955677/product/rlc4xh7ze52qx9ofibwk.jpg	f	\N	\N	\N	2026-10-25 19:14:38.359	2026-10-25 19:14:38.359
f27e4413-4df4-4107-baf8-1429a32e107b	5f5cc789-3c3d-4465-996d-cdd8fd8b90bb	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955691/product/sahcdkkvid9vwibvksfe.jpg	f	\N	\N	\N	2026-10-25 19:14:51.582	2026-10-25 19:14:51.582
937a2889-bb6f-4955-800c-8bf7ab91b8ac	5f5cc789-3c3d-4465-996d-cdd8fd8b90bb	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955700/product/krofh7b1atpjgki8uxb7.jpg	f	\N	\N	\N	2026-10-25 19:15:01.032	2026-10-25 19:15:01.032
2d4bc574-a079-4dc1-97c5-319aa3bf6515	2099a22c-4955-44c4-af6b-6616e133247e	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955723/product/qudvbzqjfqlcghaf0okg.jpg	f	\N	\N	\N	2026-10-25 19:15:23.839	2026-10-25 19:15:23.839
1a0cde9b-934c-4910-958c-a24381773e4c	2099a22c-4955-44c4-af6b-6616e133247e	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955729/product/wvdhkwxtwzfquoydywgx.jpg	f	\N	\N	\N	2026-10-25 19:15:29.366	2026-10-25 19:15:29.366
988da827-7af1-458e-b0c4-738ac0c44116	2099a22c-4955-44c4-af6b-6616e133247e	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955733/product/ymgutwdueo1llibvi8bd.jpg	f	\N	\N	\N	2026-10-25 19:15:34.274	2026-10-25 19:15:34.274
8201f99e-09f6-4f59-bee6-070874a0f711	7901703c-e519-4da1-a4b3-86939d3cfe3e	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955749/product/nfspuhr8ih63hhq9fju3.jpg	f	\N	\N	\N	2026-10-25 19:15:49.899	2026-10-25 19:15:49.899
b68ed4ff-f071-4d5d-a247-e9b9cb5c43a5	7901703c-e519-4da1-a4b3-86939d3cfe3e	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955758/product/rg7aoum6q9z2zftevw6y.jpg	f	\N	\N	\N	2026-10-25 19:15:58.458	2026-10-25 19:15:58.458
8e1ba310-6ad7-4f25-bb44-54a9fcb28015	d33c9a0f-7907-4cab-a8a2-d6e8bb27dd6a	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955789/product/i1n5tktluqg1ubinzb9h.jpg	f	\N	\N	\N	2026-10-25 19:16:29.85	2026-10-25 19:16:29.85
7c2560e0-f16e-4bfd-ac25-aa9b6521ac55	d33c9a0f-7907-4cab-a8a2-d6e8bb27dd6a	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955794/product/kh7keb0jecvxwitsechx.jpg	f	\N	\N	\N	2026-10-25 19:16:34.719	2026-10-25 19:16:34.719
6bfa0f87-e902-4bc6-a89d-bd23cd98a142	d33c9a0f-7907-4cab-a8a2-d6e8bb27dd6a	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955800/product/s3eye0bdxd9tsgv8apta.jpg	f	\N	\N	\N	2026-10-25 19:16:41.175	2026-10-25 19:16:41.175
f6414801-9803-4ceb-94a6-6b7cb66ad873	00dcbfd7-09e0-444d-8914-9a5c26b4ac8f	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955816/product/y5iaebphyuxfv9xux2yc.webp	f	\N	\N	\N	2026-10-25 19:16:56.465	2026-10-25 19:16:56.465
c7bce14e-0815-406a-94e5-132d77cb590b	8aa29284-2997-4130-bc55-a213eb620567	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955833/product/x7bhcwtbioaiffprgo0w.png	f	\N	\N	\N	2026-10-25 19:17:14.249	2026-10-25 19:17:14.249
662961af-4070-41e4-acb1-45abb2681dfa	8aa29284-2997-4130-bc55-a213eb620567	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955840/product/twraczyt8vsnxemco7rv.png	f	\N	\N	\N	2026-10-25 19:17:20.552	2026-10-25 19:17:20.552
d1239b76-efdc-4030-afe5-6eb3499b4942	8aa29284-2997-4130-bc55-a213eb620567	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955848/product/hg5jlcyfb6jb4tuhcxbl.png	f	\N	\N	\N	2026-10-25 19:17:29.225	2026-10-25 19:17:29.225
a638e10f-c3f1-4a4c-8930-eb72e5eb99ac	76572a8c-9d93-4f7e-9e4b-0b396ef9a742	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955865/product/p37l6sevdiirxdcbhohx.jpg	f	\N	\N	\N	2026-10-25 19:17:46.774	2026-10-25 19:17:46.774
692e9a71-715a-4e2e-84c1-f1ab59cc8078	76572a8c-9d93-4f7e-9e4b-0b396ef9a742	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955873/product/ug3vts8kh6c8vrw3xwee.jpg	f	\N	\N	\N	2026-10-25 19:17:53.653	2026-10-25 19:17:53.653
03b0bfef-973f-4ded-a97b-df2c56d9b8f4	76572a8c-9d93-4f7e-9e4b-0b396ef9a742	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955879/product/er5t583anmff6jvmev2e.jpg	f	\N	\N	\N	2026-10-25 19:17:59.331	2026-10-25 19:17:59.331
ddaf50b6-7018-4d7e-8727-db1131453388	f3bb6102-568b-4ca1-b0e5-e4288083c0a9	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955897/product/zz2hff4wccnab8k3ygam.webp	f	\N	\N	\N	2026-10-25 19:18:17.758	2026-10-25 19:18:17.758
a0965586-973d-4615-868e-09953092e756	f879d781-a80d-49db-a89f-5696b0cb9e8b	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955924/product/sxrvoncj4icxb0mbzkga.jpg	f	\N	\N	\N	2026-10-25 19:18:44.35	2026-10-25 19:18:44.35
abb287b5-9c13-4cab-a5d6-995b65976bea	f879d781-a80d-49db-a89f-5696b0cb9e8b	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955932/product/eaybrlfvhinr1t6wuiue.jpg	f	\N	\N	\N	2026-10-25 19:18:53.231	2026-10-25 19:18:53.231
274d9655-7e90-4fa7-bfc7-f19cd6f016bb	01202189-9e12-43b5-b326-d2324501ed7e	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955974/product/buuwszpycu2fztz0jdmh.jpg	f	\N	\N	\N	2026-10-25 19:19:34.668	2026-10-25 19:19:34.668
4534d94c-8087-4b85-b30b-e6faf4715d3f	01202189-9e12-43b5-b326-d2324501ed7e	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792955982/product/vhztdbajsk87yf1qbjvh.jpg	f	\N	\N	\N	2026-10-25 19:19:42.454	2026-10-25 19:19:42.454
9ee18f9c-4113-40ca-8c8f-a3b8bc3cc8c4	0c9c47a1-7ad0-44d8-84e4-4749ed749ce8	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956010/product/uohajrl2qojv8nfm0ymr.png	f	\N	\N	\N	2026-10-25 19:20:11.172	2026-10-25 19:20:11.172
6746a2ad-c784-4a29-a82f-a82fc37f7042	0c9c47a1-7ad0-44d8-84e4-4749ed749ce8	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956018/product/rsmlnf4ccovripmzm4o4.jpg	f	\N	\N	\N	2026-10-25 19:20:19.047	2026-10-25 19:20:19.047
e8aafe22-03ef-4dda-9177-8366b2f6e6bb	89df97a3-38e3-4c2f-ad60-744d1bf7268a	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956041/product/u51ozovp8gu6jk0ixusm.webp	f	\N	\N	\N	2026-10-25 19:20:41.501	2026-10-25 19:20:41.501
d6840470-5b2c-4155-bb5b-f03290df0760	bb146b31-8b60-43ed-a111-42ea9857c147	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956057/product/vexjjvtr1397v7jeimey.jpg	f	\N	\N	\N	2026-10-25 19:20:57.344	2026-10-25 19:20:57.344
eb94659f-f112-4674-a3d3-2ed3c4cb28fd	bb146b31-8b60-43ed-a111-42ea9857c147	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956068/product/fnunxmvsuy5tfgsmssyt.png	f	\N	\N	\N	2026-10-25 19:21:09.079	2026-10-25 19:21:09.079
33d4d705-c491-436d-83b7-b5f0629f9fdb	28e5cb99-585c-4d50-a9aa-ca51f3770849	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956081/product/eyncvnvd214ky73h9tlp.jpg	f	\N	\N	\N	2026-10-25 19:21:22.408	2026-10-25 19:21:22.408
af121601-9e15-441f-8d4a-80dc9f621867	28e5cb99-585c-4d50-a9aa-ca51f3770849	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956087/product/k8bjlws1apmqyku0z0dv.jpg	f	\N	\N	\N	2026-10-25 19:21:27.616	2026-10-25 19:21:27.616
165751f3-81e9-4c41-a84d-8ea1ef5b04cb	577a4010-5a2b-405a-a8d2-4b066bcf4372	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956109/product/gutnlkem6vvx77og9ovj.jpg	f	\N	\N	\N	2026-10-25 19:21:49.727	2026-10-25 19:21:49.727
99b318ac-57b8-43c4-bf14-32d159a47e41	577a4010-5a2b-405a-a8d2-4b066bcf4372	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956123/product/hndxtw3pxeuwjdbjduk7.jpg	f	\N	\N	\N	2026-10-25 19:22:03.585	2026-10-25 19:22:03.585
25064134-f27c-4f86-9c63-bdc15f8d4b21	577a4010-5a2b-405a-a8d2-4b066bcf4372	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956135/product/dxamtrtg2pyobljwxkgx.jpg	f	\N	\N	\N	2026-10-25 19:22:15.559	2026-10-25 19:22:15.559
ab403238-5d07-4cf8-af4d-ca5746ac576a	cd777e93-c96c-4ef3-90d3-42c240452c79	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956168/product/zcfwfu5khuujlhfa1wen.jpg	f	\N	\N	\N	2026-10-25 19:22:49.429	2026-10-25 19:22:49.429
9e64a77a-99bd-457e-ba19-9cb3794cee57	38069b07-6fd4-4a53-9d7c-ff6e52ebfdec	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956182/product/iwadaoliyo881mvgqeib.jpg	f	\N	\N	\N	2026-10-25 19:23:02.947	2026-10-25 19:23:02.947
21f74c79-5203-42da-955c-906047d8840a	38069b07-6fd4-4a53-9d7c-ff6e52ebfdec	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956194/product/uadm4pvtik76fgrlo0u4.jpg	f	\N	\N	\N	2026-10-25 19:23:15.337	2026-10-25 19:23:15.337
7a30e747-2294-48fd-94e3-aa13a948080a	4ed57174-1e05-4c61-b41f-2b3ea9c04474	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956217/product/z9agleluhfypaklgygz3.jpg	f	\N	\N	\N	2026-10-25 19:23:38.329	2026-10-25 19:23:38.329
0a968f45-4196-4fe9-8c4f-ad9eb3bf8eb9	4ed57174-1e05-4c61-b41f-2b3ea9c04474	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956225/product/qslzfczwf9j3gbuvwbkt.jpg	f	\N	\N	\N	2026-10-25 19:23:46.174	2026-10-25 19:23:46.174
10087f47-a79a-4d38-a0aa-c32ac9089395	6a962db6-57a7-452c-b531-e85eb8124381	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956246/product/ti6dwdeii06fpodel3a8.webp	f	\N	\N	\N	2026-10-25 19:24:06.732	2026-10-25 19:24:06.732
448920d6-a5a8-4a49-af09-65eab7477626	ee919d96-1dac-4543-964a-e0665d8e9dce	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956271/product/lba59wjpxy1swxpmfxhq.png	f	\N	\N	\N	2026-10-25 19:24:32.269	2026-10-25 19:24:32.269
13861c36-fbf8-4337-8cca-6b870bb7249f	ee919d96-1dac-4543-964a-e0665d8e9dce	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956278/product/e2mocsteaz7f9qc7lnvm.png	f	\N	\N	\N	2026-10-25 19:24:38.819	2026-10-25 19:24:38.819
da983a85-6398-442e-8465-b76466c07ca9	7ac3b222-81bc-4051-b492-27cf0142b6a5	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956294/product/t36wlzsbvuzahn0sxuyx.jpg	f	\N	\N	\N	2026-10-25 19:24:54.69	2026-10-25 19:24:54.69
c5cfe558-a5e4-4620-9b15-719d8eb1021b	595623cb-ccdd-4b60-9d88-a6b2a41f6e8d	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956310/product/lo72r6oa6kulf7qeb63q.jpg	f	\N	\N	\N	2026-10-25 19:25:11.105	2026-10-25 19:25:11.105
eb2a4e11-42fe-4442-8f13-389258aa194e	75344aab-495a-4514-9874-8e3dfd4b4c6c	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956329/product/yjpyipkdqcgvizbz2fjz.webp	f	\N	\N	\N	2026-10-25 19:25:29.62	2026-10-25 19:25:29.62
dde53164-7fc5-4834-8af2-7564223a2ef5	75344aab-495a-4514-9874-8e3dfd4b4c6c	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956338/product/b6r6fykzsh75nkmfx0lk.webp	f	\N	\N	\N	2026-10-25 19:25:38.591	2026-10-25 19:25:38.591
6b3f109f-6d32-4582-8b82-1ea274304b9f	6c12238d-aca0-4b2d-9878-f4ccff229f5f	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956359/product/wlrraollfm8dgcqkumdb.jpg	f	\N	\N	\N	2026-10-25 19:25:59.909	2026-10-25 19:25:59.909
71f46d73-926a-42e8-aa0d-c3df2157ae0f	bb727eef-e84a-447a-8616-75d05d7295eb	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956377/product/bi6bykhzt0a4j89xrny9.jpg	f	\N	\N	\N	2026-10-25 19:26:17.664	2026-10-25 19:26:17.664
f52061d5-03c7-4d92-bcd7-b9002a100b98	236dc197-0259-43c5-a617-211965cb79d3	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956408/product/qhsfdwvr84mk0qr1qrfx.jpg	f	\N	\N	\N	2026-10-25 19:26:48.818	2026-10-25 19:26:48.818
263c43d9-8573-4aac-b657-17f63edd9f4c	3d05dc8c-9258-4376-bd34-7ae5d607de69	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956426/product/nuwrwbsluadhae7ikfdk.jpg	f	\N	\N	\N	2026-10-25 19:27:07.074	2026-10-25 19:27:07.074
7aed0463-0a08-40a1-8392-e54ece3b52d0	70bb4d05-6eed-4715-b25f-888701d99160	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956441/product/p0rpxw9h1h92js0glgfr.jpg	f	\N	\N	\N	2026-10-25 19:27:21.741	2026-10-25 19:27:21.741
85ccc759-8ee8-43b9-9656-1f90895d3257	f2ecd448-5075-400c-bad2-b35a3b431488	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956457/product/sllpcfx45tzaolahmcyi.jpg	f	\N	\N	\N	2026-10-25 19:27:37.8	2026-10-25 19:27:37.8
c650e1e8-d2ec-490e-9528-117c8f242829	5fe94ebe-ec81-4ece-9546-1d1b64a2b3b1	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956470/product/twrtatlpjbj84snv3fha.jpg	f	\N	\N	\N	2026-10-25 19:27:50.695	2026-10-25 19:27:50.695
33fa46d4-52f3-46e6-8782-9fd333e811e9	89bd7a27-277c-4dff-8520-6b8ba6003076	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956490/product/bokrfgw7jrerassw156n.jpg	f	\N	\N	\N	2026-10-25 19:28:10.555	2026-10-25 19:28:10.555
90fa100d-e86e-459c-be16-243ac09981a3	59423c56-cb3c-4972-857d-fde874e5a08a	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956516/product/ohwir4rxpfrnorifzdfo.jpg	f	\N	\N	\N	2026-10-25 19:28:36.591	2026-10-25 19:28:36.591
af795c52-8112-480c-a3d5-c1cf9cc14ca3	59423c56-cb3c-4972-857d-fde874e5a08a	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956523/product/ttnkpgvlrixmqekxmhlf.jpg	f	\N	\N	\N	2026-10-25 19:28:44.01	2026-10-25 19:28:44.01
183fba2c-f813-4e11-99c0-e00ec51b2bea	43c8297b-4dc8-41b3-ad98-3411237a95b2	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956544/product/qiacfebnho37ruqc1vav.jpg	f	\N	\N	\N	2026-10-25 19:29:05.424	2026-10-25 19:29:05.424
82f74159-3c48-4598-8c7e-095b019bd8fe	9db7bb7f-bbcf-47c6-82e6-c83640206bc6	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956559/product/varhnumjbciw1jppuurm.jpg	f	\N	\N	\N	2026-10-25 19:29:19.978	2026-10-25 19:29:19.978
831856b5-7264-48b6-a722-3f921020ad0f	9d7c598a-dbdb-4ab2-bf06-277e66287d68	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956592/product/ynfhok81fdt3dldstkaj.jpg	f	\N	\N	\N	2026-10-25 19:29:53.276	2026-10-25 19:29:53.276
bf1439f3-c922-4c26-9299-195430b0ff2e	0f0d37c4-ce81-4c42-8ecf-f155ea347be9	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956619/product/ztak8drwgcwst3qsturl.jpg	f	\N	\N	\N	2026-10-25 19:30:20.32	2026-10-25 19:30:20.32
f03c86f3-86eb-45e3-9f03-7c9f9c89949b	0f0d37c4-ce81-4c42-8ecf-f155ea347be9	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956628/product/y56xfxrwnalycfstxjow.jpg	f	\N	\N	\N	2026-10-25 19:30:28.63	2026-10-25 19:30:28.63
5b0befff-a2b6-47f8-8f4f-be5b061e87dc	1a0b08b6-6f05-4cbf-bbb8-004e256223cd	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956664/product/kmletsr2nggxopxjps56.webp	f	\N	\N	\N	2026-10-25 19:31:05.304	2026-10-25 19:31:05.304
6aa2fba9-91da-446a-8f4d-f5f276ee62b3	1a0b08b6-6f05-4cbf-bbb8-004e256223cd	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956671/product/phhq2fxkj7ccfiwzz1af.jpg	f	\N	\N	\N	2026-10-25 19:31:12.041	2026-10-25 19:31:12.041
69225a2d-24f1-4475-b9cd-1ddafb74734c	ef7e970f-a415-45f4-b98b-0aa741925ea3	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956697/product/xeqqqj92sht0nvdpmeya.jpg	f	\N	\N	\N	2026-10-25 19:31:37.603	2026-10-25 19:31:37.603
4a88e8a8-54b1-42cc-9c4d-510b4dfdc74c	ef7e970f-a415-45f4-b98b-0aa741925ea3	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956704/product/cupbzviwzhsjvkumnczf.jpg	f	\N	\N	\N	2026-10-25 19:31:44.794	2026-10-25 19:31:44.794
2c8eac38-07e0-4e1b-ba5a-aee88e892958	a7ec4f21-b399-40c5-8039-a020818df6c3	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956720/product/xngp9qsilbn5qanohprc.jpg	f	\N	\N	\N	2026-10-25 19:32:00.714	2026-10-25 19:32:00.714
29a0d39a-f8d8-46d9-bcb0-a250b285f413	2c968541-ab7c-42f5-b976-7383fad98ab8	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956742/product/qy4dia2vufd3zuoyzphm.jpg	f	\N	\N	\N	2026-10-25 19:32:23.682	2026-10-25 19:32:23.682
ef6c314c-df34-4b9a-9079-cd8ccd024910	2c968541-ab7c-42f5-b976-7383fad98ab8	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956749/product/kilgxvwdpd2wbl74rlkf.jpg	f	\N	\N	\N	2026-10-25 19:32:29.691	2026-10-25 19:32:29.691
ac57a659-4bd8-4abb-9ea0-0695310f7752	2c968541-ab7c-42f5-b976-7383fad98ab8	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956755/product/ap5pyxrkrickisck0fnk.jpg	f	\N	\N	\N	2026-10-25 19:32:35.858	2026-10-25 19:32:35.858
f8890e73-0889-486e-a5b5-f82968244fe8	7626fb97-054a-4be1-ac2f-827fb07a479f	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956775/product/gi4flva0rwxn2jwbaevw.jpg	f	\N	\N	\N	2026-10-25 19:32:55.834	2026-10-25 19:32:55.834
d3bf7731-5ac1-498d-ad12-0045ac9ac8e2	d6d2ff2b-b9b3-4e46-9225-9ab39bae6071	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956816/product/clksupi6wtjonpv1l5gc.jpg	f	\N	\N	\N	2026-10-25 19:33:37.053	2026-10-25 19:33:37.053
472aefa5-f3b1-4911-a84f-e315cbf96a4c	d6d2ff2b-b9b3-4e46-9225-9ab39bae6071	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956819/product/rj6rg4myqyzbj0af44r8.jpg	f	\N	\N	\N	2026-10-25 19:33:39.851	2026-10-25 19:33:39.851
38512dcf-8ed0-49d4-b6d0-df2cf8a55044	43d3274b-0bc4-4c12-98ff-af2350f69402	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956837/product/yeyw0u3rb98va7wm5yao.jpg	f	\N	\N	\N	2026-10-25 19:33:58.92	2026-10-25 19:33:58.92
7c816351-e762-4134-95ce-c6b23f21cf1d	43d3274b-0bc4-4c12-98ff-af2350f69402	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956857/product/ixpm4sciu8wd1hsweuki.jpg	f	\N	\N	\N	2026-10-25 19:34:18.039	2026-10-25 19:34:18.039
42a13d84-4de5-47ce-80a8-964dcea6d330	da2ae24e-1027-45b7-a7ba-6e0c4a66f678	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956879/product/otddveak7xto285sdfz6.jpg	f	\N	\N	\N	2026-10-25 19:34:40.211	2026-10-25 19:34:40.211
47b7f800-80b4-4d60-88d2-5fc74b7000e4	da2ae24e-1027-45b7-a7ba-6e0c4a66f678	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956888/product/qcbcbe81e3brwdlgfk3z.png	f	\N	\N	\N	2026-10-25 19:34:48.8	2026-10-25 19:34:48.8
8c3c1b44-7084-4d4f-907b-4894d84183df	da2ae24e-1027-45b7-a7ba-6e0c4a66f678	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956900/product/pl75aqaa1qa5kzp7wrho.jpg	f	\N	\N	\N	2026-10-25 19:35:00.941	2026-10-25 19:35:00.941
36783c41-e400-4bc0-9e6b-10735ff5bbeb	9ea58a0c-9562-4d62-a59d-77ca5fe66741	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956918/product/mfwsoilqn3pahe6xcmoh.jpg	f	\N	\N	\N	2026-10-25 19:35:18.446	2026-10-25 19:35:18.446
3b092568-01d9-40cc-bda6-a823843beec5	9ea58a0c-9562-4d62-a59d-77ca5fe66741	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956925/product/mtb4f6jrjlul7dbcr7vi.jpg	f	\N	\N	\N	2026-10-25 19:35:25.98	2026-10-25 19:35:25.98
7a95865a-ee87-48a9-a68d-ab92292954a3	71d4df0b-e4a9-4c8a-aa54-317261858859	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956950/product/n9ygz3hqcvqh3duxrsvd.jpg	f	\N	\N	\N	2026-10-25 19:35:51.096	2026-10-25 19:35:51.096
66c2ebdf-31a2-4c46-91b4-785646eb6efe	71d4df0b-e4a9-4c8a-aa54-317261858859	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956956/product/y5tus1ezu5kp0c0ixtjj.jpg	f	\N	\N	\N	2026-10-25 19:35:56.922	2026-10-25 19:35:56.922
aafc7847-c0b1-417e-9455-dd53b38c6944	71d4df0b-e4a9-4c8a-aa54-317261858859	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956962/product/pitft871xxbrpghrh5um.jpg	f	\N	\N	\N	2026-10-25 19:36:02.658	2026-10-25 19:36:02.658
5f5a6923-1930-4d0e-9464-364a9d8b889c	e17bfcd9-17b0-4adb-be18-d7d8f1e8d7f1	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956983/product/cc6eyoensylubqfz13ta.jpg	f	\N	\N	\N	2026-10-25 19:36:24.241	2026-10-25 19:36:24.241
4d954381-6556-4bcc-bf14-d3beb1873112	e17bfcd9-17b0-4adb-be18-d7d8f1e8d7f1	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956983/product/jp7spbb8tddn7aasd872.jpg	f	\N	\N	\N	2026-10-25 19:36:24.274	2026-10-25 19:36:24.274
fb7e4fe3-b415-4be9-aae7-657b7a20d913	e17bfcd9-17b0-4adb-be18-d7d8f1e8d7f1	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792956992/product/jrqm3a7gxkf5pnnmeqau.jpg	f	\N	\N	\N	2026-10-25 19:36:33.135	2026-10-25 19:36:33.135
5586fc1b-6114-451b-b341-6198898b7ba1	e17bfcd9-17b0-4adb-be18-d7d8f1e8d7f1	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792957002/product/gebupginfbikt3gqgsgd.jpg	f	\N	\N	\N	2026-10-25 19:36:43.242	2026-10-25 19:36:43.242
4b6653c0-8e23-4e50-b3ab-771a534111fd	e89d6f03-391c-48c3-84ce-02e1e28a6ec6	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792957048/product/idigtvsioyetheomxdzi.jpg	f	\N	\N	\N	2026-10-25 19:37:28.976	2026-10-25 19:37:28.976
10a4c845-684c-408e-bb66-12c412d367dc	9b728cfe-d1d2-44ea-bec4-379216652a51	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792957067/product/thlbzxmyuqocazydzxtr.jpg	f	\N	\N	\N	2026-10-25 19:37:48.042	2026-10-25 19:37:48.042
ed349084-7865-49f6-bdcf-104e6cd84dc2	ecbc1023-f440-4569-8772-0409b82150ae	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792957081/product/kjngi5ymtzfos5qhsvyx.jpg	f	\N	\N	\N	2026-10-25 19:38:01.946	2026-10-25 19:38:01.946
06e9e3c4-5b95-434d-8a4e-9938cf27a9f1	4e8ad248-7b05-42bf-9974-95ded09be7b3	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792957096/product/eaghrzpm4qpgyae7at6q.jpg	f	\N	\N	\N	2026-10-25 19:38:16.43	2026-10-25 19:38:16.43
9e390260-36c7-45b3-8e49-dba740c1f96d	4e8ad248-7b05-42bf-9974-95ded09be7b3	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792957107/product/slljj2unslvi8zo0ux1u.jpg	f	\N	\N	\N	2026-10-25 19:38:27.883	2026-10-25 19:38:27.883
e7e94c27-44cb-4c9b-883a-a9171ce440e8	0ceab60b-154c-4f0a-b16f-4d8e6628b1e5	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792957135/product/ih05vjw4kfmzjdsz7fte.jpg	f	\N	\N	\N	2026-10-25 19:38:55.663	2026-10-25 19:38:55.663
9af723aa-3b4f-40a1-9169-264b182fc1fb	0ceab60b-154c-4f0a-b16f-4d8e6628b1e5	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792957150/product/tb7pqrl8clid5e8hpqdh.jpg	f	\N	\N	\N	2026-10-25 19:39:10.908	2026-10-25 19:39:10.908
2efc59e9-31da-4619-acae-f90e29a62af4	dab94f06-0e68-44c8-b458-c00011013d51	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792957169/product/ybdnoju1ilbcymcg8sjk.jpg	f	\N	\N	\N	2026-10-25 19:39:30.171	2026-10-25 19:39:30.171
e51b54c9-3c7d-4333-88f9-03687ba45dba	ae7c9c8d-086a-4e84-a419-33871d80d88f	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792957222/product/gaj8cz2eakjbrsdq4q2r.jpg	f	\N	\N	\N	2026-10-25 19:40:22.579	2026-10-25 19:40:22.579
60ccf3a2-8d38-4ef6-8fe6-0da53a15f421	ae7c9c8d-086a-4e84-a419-33871d80d88f	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792957230/product/oypq2t5zviyvvd9fi35u.jpg	f	\N	\N	\N	2026-10-25 19:40:31.192	2026-10-25 19:40:31.192
f2fad3c7-fb93-41ed-9617-c4dfe673a15f	c90772e3-8704-4479-bcf0-ddb20fb726be	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792957246/product/yxbvrjy0bqxlbtda7gve.jpg	f	\N	\N	\N	2026-10-25 19:40:46.641	2026-10-25 19:40:46.641
db70a4c2-971c-49fb-97e8-ff3e573f9cc4	c90772e3-8704-4479-bcf0-ddb20fb726be	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792957251/product/rbq1px0ixylrlyyzclho.jpg	f	\N	\N	\N	2026-10-25 19:40:52.258	2026-10-25 19:40:52.258
74b46fb4-f4da-4e7b-a75c-fd9bcf9025e4	6e3a75fe-be49-4e90-ba55-452458ca8db2	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792957265/product/mrvcyy6myo2cxwvqlil4.jpg	f	\N	\N	\N	2026-10-25 19:41:05.986	2026-10-25 19:41:05.986
66fb8ccc-d742-4a7b-8271-cb7e6e2fe3fd	6e3a75fe-be49-4e90-ba55-452458ca8db2	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792957390/product/tzlut8nnzeegrfxrly8a.jpg	f	\N	\N	\N	2026-10-25 19:43:11.322	2026-10-25 19:43:11.322
\.


--
-- Data for Name: Review; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Review" (id, "productId", "userId", rating, comment, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Role; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Role" (id, name, price, "isDeleted", "createdBy", "updatedBy", "deletedBy", "createdAt", "updatedAt") FROM stdin;
c21e9bfb-7363-45ef-872b-44072c9eab20	super-admin	0	f	\N	\N	\N	2025-02-08 20:25:48.606	2025-02-08 20:25:48.606
994302f0-3fa1-427d-9c6c-f7b29e00652c	admin	0	f	\N	\N	\N	2025-02-08 20:25:50.388	2025-02-08 20:25:50.388
51c3a14d-55e8-4103-b84e-0906f08fe41d	manager	0	f	\N	\N	\N	2025-02-08 20:25:51.231	2025-02-08 20:25:51.231
7e1dbe8e-b9e2-48d3-a215-0e36a5839f16	basic	20000	f	\N	\N	\N	2025-02-08 20:25:51.864	2025-02-08 20:25:51.864
cf8ffdf2-c5b5-4a68-a4f9-ecb88d625e2b	standard	35000	f	\N	\N	\N	2025-02-08 20:25:52.659	2025-02-08 20:25:52.659
0f89ce29-cd4a-4b84-998e-f3f97416d8f8	premium	50000	f	\N	\N	\N	2025-02-08 20:25:53.214	2025-02-08 20:25:53.214
1a843360-237c-4dce-ba8b-9a077bafdd1e	customer	0	f	\N	\N	\N	2025-02-08 20:25:53.887	2025-02-08 20:25:53.887
\.


--
-- Data for Name: RoleModule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."RoleModule" (id, "roleId", "moduleId", "isDeleted", "createdBy", "updatedBy", "deletedBy", "createdAt", "updatedAt") FROM stdin;
a156d143-407b-4bc5-b8e2-699daa0cd670	c21e9bfb-7363-45ef-872b-44072c9eab20	fc81a5e1-444d-47ec-aefc-821a7c4926db	f	\N	\N	\N	2025-02-08 20:26:29.525	2025-02-08 20:26:29.525
1d7c616b-2f6a-4e45-b1b4-aa0da49c10e7	c21e9bfb-7363-45ef-872b-44072c9eab20	df0324f1-726c-4b88-b647-740112f81af3	f	\N	\N	\N	2025-02-08 20:26:30.342	2025-02-08 20:26:30.342
3920bdfc-9a8c-4a42-939a-b81ac958fd73	c21e9bfb-7363-45ef-872b-44072c9eab20	33aff310-5bdc-44fb-b70c-6bfa0eb1c44e	f	\N	\N	\N	2025-02-08 20:26:30.752	2025-02-08 20:26:30.752
ca232eb4-2acf-44cb-92b7-f6e83edd5a44	c21e9bfb-7363-45ef-872b-44072c9eab20	20b00bcd-abef-4f42-b4bd-f9f87c3b459b	f	\N	\N	\N	2025-02-08 20:26:31.163	2025-02-08 20:26:31.163
0c179185-af16-49e2-a9f3-f597234b7170	c21e9bfb-7363-45ef-872b-44072c9eab20	ab236e0a-e177-47bc-996e-7957f5f74024	f	\N	\N	\N	2025-02-08 20:26:31.571	2025-02-08 20:26:31.571
781f682a-a579-4244-b884-cc5088ed2793	c21e9bfb-7363-45ef-872b-44072c9eab20	45b87d20-7698-47f6-b06e-d54b0a21447a	f	\N	\N	\N	2025-02-08 20:26:31.984	2025-02-08 20:26:31.984
2d0763b0-10d6-45c6-b0f4-7a81822f50af	c21e9bfb-7363-45ef-872b-44072c9eab20	5bbc149a-cf58-4cf1-bede-e83a70ba04e0	f	\N	\N	\N	2025-02-08 20:26:32.386	2025-02-08 20:26:32.386
dc8160d8-2352-4b23-9b26-32f61e2b016e	c21e9bfb-7363-45ef-872b-44072c9eab20	745e873c-f2c6-4dca-8468-ac6097aac834	f	\N	\N	\N	2025-02-08 20:26:32.797	2025-02-08 20:26:32.797
b07bcc34-7167-434f-be26-6432dc7e9969	c21e9bfb-7363-45ef-872b-44072c9eab20	884afff8-2321-4a70-bb55-8c1daea5f323	f	\N	\N	\N	2025-02-08 20:26:33.314	2025-02-08 20:26:33.314
d4d185ef-3ba1-44cd-aa9b-55abfe94984b	c21e9bfb-7363-45ef-872b-44072c9eab20	a0f80dce-b64f-4f74-9f2e-03875b907890	f	\N	\N	\N	2025-02-08 20:26:33.732	2025-02-08 20:26:33.732
73931612-bc20-4478-98a7-b591cebfd3f6	c21e9bfb-7363-45ef-872b-44072c9eab20	75fe294f-8426-4f59-8e6e-0b006883b592	f	\N	\N	\N	2025-02-08 20:26:34.131	2025-02-08 20:26:34.131
2251d527-9b22-4d48-8b16-9623add3711a	c21e9bfb-7363-45ef-872b-44072c9eab20	256fb7e5-145d-44b5-a372-c8cb87f084da	f	\N	\N	\N	2025-02-08 20:26:34.708	2025-02-08 20:26:34.708
66fcd27c-c163-4007-99be-bc4016dd1140	c21e9bfb-7363-45ef-872b-44072c9eab20	42311836-00d8-46a5-99c0-ad0e0f552a0f	f	\N	\N	\N	2025-02-08 20:26:35.357	2025-02-08 20:26:35.357
f8066109-136d-4b84-9755-d67827127257	c21e9bfb-7363-45ef-872b-44072c9eab20	81c49ff4-d4da-4088-b250-b5b658c65e12	f	\N	\N	\N	2025-02-08 20:26:35.976	2025-02-08 20:26:35.976
548b6107-5da6-44f6-a4f5-9a4a61da8641	c21e9bfb-7363-45ef-872b-44072c9eab20	85b92126-f6b7-4964-a411-556d3acfb309	f	\N	\N	\N	2025-02-08 20:26:36.384	2025-02-08 20:26:36.384
f1ebadeb-9b4b-4d37-9476-f8778c252ec8	c21e9bfb-7363-45ef-872b-44072c9eab20	92a1b8e3-3004-4d68-85e1-209fd8876114	f	\N	\N	\N	2025-02-08 20:26:36.898	2025-02-08 20:26:36.898
34c7b28c-045e-4d33-90b1-1ad21d1a3a23	c21e9bfb-7363-45ef-872b-44072c9eab20	80d2ab31-cb37-4565-9e41-b8842fe7994b	f	\N	\N	\N	2025-02-08 20:26:37.248	2025-02-08 20:26:37.248
96eaebea-585b-4221-a72a-70594c9d5c72	c21e9bfb-7363-45ef-872b-44072c9eab20	84ad5fe7-6d06-45c8-968c-3b5125efd4e9	f	\N	\N	\N	2025-02-08 20:26:37.716	2025-02-08 20:26:37.716
bc01082a-28af-4616-9290-776a813d2b56	c21e9bfb-7363-45ef-872b-44072c9eab20	fc92d13b-bf35-40a5-8c05-7713b9cacd3c	f	\N	\N	\N	2025-02-08 20:26:38.644	2025-02-08 20:26:38.644
e6900a67-929d-4adb-98fa-a84d436ffa20	c21e9bfb-7363-45ef-872b-44072c9eab20	a9593357-c239-4147-a1bc-a3b99c728e25	f	\N	\N	\N	2025-02-08 20:26:39.058	2025-02-08 20:26:39.058
c248dde9-ad2f-49a8-a6ae-6e21d217e466	c21e9bfb-7363-45ef-872b-44072c9eab20	3caa8d0d-c25c-464b-b9ad-0103afd9d5a3	f	\N	\N	\N	2025-02-08 20:26:39.869	2025-02-08 20:26:39.869
f7bc94ce-0efd-4361-9fd0-f57d36bb0985	c21e9bfb-7363-45ef-872b-44072c9eab20	5b31611c-76df-4188-bdca-ee4fa0f6aaf4	f	\N	\N	\N	2025-02-08 20:26:40.802	2025-02-08 20:26:40.802
c53b800d-6c01-487f-a276-1a77f0097616	c21e9bfb-7363-45ef-872b-44072c9eab20	e53ecf48-8ebb-4e39-a1ce-033c8830b130	f	\N	\N	\N	2025-02-08 20:26:41.173	2025-02-08 20:26:41.173
127819f0-211e-492f-a39f-e420c65e7719	c21e9bfb-7363-45ef-872b-44072c9eab20	a3133e01-b9c6-4dc2-b462-dd79e4347117	f	\N	\N	\N	2025-02-08 20:26:41.707	2025-02-08 20:26:41.707
d36f795b-7b14-4fa2-abea-525e142601a0	c21e9bfb-7363-45ef-872b-44072c9eab20	1fd5bd5f-3b68-443e-86e4-021ba0a07328	f	\N	\N	\N	2025-02-08 20:26:42.1	2025-02-08 20:26:42.1
f5be5692-2c33-4eb5-b7c1-1688ba2d786e	c21e9bfb-7363-45ef-872b-44072c9eab20	b94673dc-2475-4c59-819a-90a86d52b1e9	f	\N	\N	\N	2025-02-08 20:26:42.834	2025-02-08 20:26:42.834
08273c33-6539-406a-a885-1f2358106412	c21e9bfb-7363-45ef-872b-44072c9eab20	3f3d745c-a6ba-4d2c-a8ca-d2582733b602	f	\N	\N	\N	2025-02-08 20:26:43.345	2025-02-08 20:26:43.345
69eb59f4-0e6e-4437-b77f-04d91177a3bf	c21e9bfb-7363-45ef-872b-44072c9eab20	0187fdc4-8580-4179-9271-c4724abaf273	f	\N	\N	\N	2025-02-08 20:26:44.209	2025-02-08 20:26:44.209
09289f95-8cc3-4bc0-a9a3-dae3368a0b2f	c21e9bfb-7363-45ef-872b-44072c9eab20	7eaada76-2ef6-4f85-ab58-837ac9b736fc	f	\N	\N	\N	2025-02-08 20:26:44.754	2025-02-08 20:26:44.754
ca3236d4-3e9d-4b71-98e4-0e41db8e48da	c21e9bfb-7363-45ef-872b-44072c9eab20	16732b8e-9b64-4afc-9ed3-e0f474612031	f	\N	\N	\N	2025-02-08 20:26:45.15	2025-02-08 20:26:45.15
2ad6ae77-2c88-4b04-83aa-cdfa018ebe55	c21e9bfb-7363-45ef-872b-44072c9eab20	d9679ae5-4624-48e2-9d52-35d7a97c159a	f	\N	\N	\N	2025-02-08 20:26:45.801	2025-02-08 20:26:45.801
f86e33a5-636e-4b3d-9451-502f3b39bd33	c21e9bfb-7363-45ef-872b-44072c9eab20	132d7341-cf18-4da4-a326-63b5971d0c5c	f	\N	\N	\N	2025-02-08 20:26:46.254	2025-02-08 20:26:46.254
00a26763-b14e-47f0-9d78-7bb2507303e7	c21e9bfb-7363-45ef-872b-44072c9eab20	e237aab8-8107-4e4e-8010-aadff5871207	f	\N	\N	\N	2025-02-08 20:26:46.823	2025-02-08 20:26:46.823
ac829a4d-d1c9-4501-bb52-9f3af7e234cf	c21e9bfb-7363-45ef-872b-44072c9eab20	5575cce7-f5d9-467f-a8ee-86d35bcfff69	f	\N	\N	\N	2025-02-08 20:26:47.219	2025-02-08 20:26:47.219
8758ea9d-d981-49ad-b147-2205a80642ed	c21e9bfb-7363-45ef-872b-44072c9eab20	231f02a4-fa63-4441-a263-94814f6bef82	f	\N	\N	\N	2025-02-08 20:26:47.709	2025-02-08 20:26:47.709
203e0716-992c-4cd9-b7ec-919366b8e689	c21e9bfb-7363-45ef-872b-44072c9eab20	2f199e3d-00fe-4814-9f5a-fe26a1475e26	f	\N	\N	\N	2025-02-08 20:26:48.433	2025-02-08 20:26:48.433
00c78448-da9a-42e6-9474-9e3f0250e8e6	c21e9bfb-7363-45ef-872b-44072c9eab20	de0394b7-c52e-4217-86a7-10430c548cc5	f	\N	\N	\N	2025-02-08 20:26:49.095	2025-02-08 20:26:49.095
587341c7-a3c3-47c1-828f-2e590bd810d7	c21e9bfb-7363-45ef-872b-44072c9eab20	3d914d10-b3f5-4681-bba7-1ec84c655e0f	f	\N	\N	\N	2025-02-08 20:26:49.593	2025-02-08 20:26:49.593
e14c8ae3-45e7-44b3-b0bb-dd3f3cf67705	c21e9bfb-7363-45ef-872b-44072c9eab20	f8c8777e-530b-47f9-9452-17531553bf78	f	\N	\N	\N	2025-02-08 20:26:50.277	2025-02-08 20:26:50.277
b1d25f70-2cd2-4aec-aadc-21881e1691be	c21e9bfb-7363-45ef-872b-44072c9eab20	ca8dfe5e-224a-4be0-b175-48852bac8e99	f	\N	\N	\N	2025-02-08 20:26:50.683	2025-02-08 20:26:50.683
4837e450-1496-4e01-94a4-9a275598acce	c21e9bfb-7363-45ef-872b-44072c9eab20	2254823e-4e85-4602-b524-9649ef1720dd	f	\N	\N	\N	2025-02-08 20:26:51.131	2025-02-08 20:26:51.131
c2a7caa4-41a9-46ba-b32b-2423ef745082	c21e9bfb-7363-45ef-872b-44072c9eab20	a1f9e476-dec3-4f58-9ca3-a65e9e1b2391	f	\N	\N	\N	2025-02-08 20:26:51.612	2025-02-08 20:26:51.612
fd8f4610-2047-4fa6-ae86-74c75d6ae579	c21e9bfb-7363-45ef-872b-44072c9eab20	36bcbed8-8f34-4b1b-b4ff-cdbdd6530fea	f	\N	\N	\N	2025-02-08 20:26:52.028	2025-02-08 20:26:52.028
b4004fb9-569e-49e8-8e5f-7e241c54ba0d	c21e9bfb-7363-45ef-872b-44072c9eab20	07f2abfe-0183-4cce-bdd0-7a6f81efd35a	f	\N	\N	\N	2025-02-08 20:26:52.43	2025-02-08 20:26:52.43
0c881a3a-2f2d-4d3a-a54b-b4a41f5a1af9	c21e9bfb-7363-45ef-872b-44072c9eab20	f53cf660-3b69-483c-b5d5-59ed41a5dd8a	f	\N	\N	\N	2025-02-08 20:26:52.84	2025-02-08 20:26:52.84
989adfcd-66c5-453b-a20f-0c76d5354d1a	c21e9bfb-7363-45ef-872b-44072c9eab20	09f0168b-0e84-4e40-b8ab-377ea5bea82a	f	\N	\N	\N	2025-02-08 20:26:53.383	2025-02-08 20:26:53.383
940c52f8-504c-45ba-a3a8-e25f78056e03	c21e9bfb-7363-45ef-872b-44072c9eab20	e56fb295-2b3d-49b3-b854-36174fc913ed	f	\N	\N	\N	2025-02-08 20:26:53.794	2025-02-08 20:26:53.794
0ce24b4f-6cdc-4c88-a0c4-3ad5fa699593	c21e9bfb-7363-45ef-872b-44072c9eab20	5fc32cb5-ad77-46d6-a025-428db7b2dfc9	f	\N	\N	\N	2025-02-08 20:26:54.506	2025-02-08 20:26:54.506
13adbaec-c69a-4eca-87bd-1648e912040a	c21e9bfb-7363-45ef-872b-44072c9eab20	1322bda1-786f-437b-aed4-990a3c8e6cd7	f	\N	\N	\N	2025-02-08 20:26:54.992	2025-02-08 20:26:54.992
7ef67561-c89b-49c0-886c-5e53ebdad2f0	c21e9bfb-7363-45ef-872b-44072c9eab20	38dd1aa4-8333-4d45-b171-6729855eb4c7	f	\N	\N	\N	2025-02-08 20:26:55.635	2025-02-08 20:26:55.635
ab12c09e-da88-452c-a0a2-71e54be9bdd8	c21e9bfb-7363-45ef-872b-44072c9eab20	065089f3-e5f0-4487-949f-4f133e826484	f	\N	\N	\N	2025-02-08 20:26:56.055	2025-02-08 20:26:56.055
22e94153-7a04-49a4-b24c-3344b0ff6e59	c21e9bfb-7363-45ef-872b-44072c9eab20	8f002ef7-953b-4a40-92cc-7765c2d6a234	f	\N	\N	\N	2025-02-08 20:26:56.555	2025-02-08 20:26:56.555
c382aa5c-20cd-43c3-bf6b-1e35c9afd7ce	c21e9bfb-7363-45ef-872b-44072c9eab20	6cc44e1b-1788-4906-8fdf-27bfc2482452	f	\N	\N	\N	2025-02-08 20:26:57.273	2025-02-08 20:26:57.273
ae77a9d6-abef-48d0-98bc-9fc30cb6aee1	c21e9bfb-7363-45ef-872b-44072c9eab20	528b9a1f-efa4-430a-8f1b-37dfff7b3a73	f	\N	\N	\N	2025-02-08 20:26:57.788	2025-02-08 20:26:57.788
8392f887-20b0-4391-a863-a5b321e847e5	c21e9bfb-7363-45ef-872b-44072c9eab20	8f0a4b43-2b2c-445a-9458-f0293efd590d	f	\N	\N	\N	2025-02-08 20:26:58.195	2025-02-08 20:26:58.195
3027f8f5-abf4-4bcf-8fbc-d761228fc16f	c21e9bfb-7363-45ef-872b-44072c9eab20	73f9a996-fd1b-4425-9075-cda154141dde	f	\N	\N	\N	2025-02-08 20:26:58.895	2025-02-08 20:26:58.895
6c87d9dd-1267-42e0-b51d-804e02fcc235	c21e9bfb-7363-45ef-872b-44072c9eab20	cc698257-10f4-4eca-a1ad-7a390a8b164d	f	\N	\N	\N	2025-02-08 20:26:59.321	2025-02-08 20:26:59.321
4d02ec0c-e253-4333-9597-7413fda9c01e	c21e9bfb-7363-45ef-872b-44072c9eab20	b8eaa65e-594a-4e19-9513-09534363f29c	f	\N	\N	\N	2025-02-08 20:26:59.831	2025-02-08 20:26:59.831
badf581e-b0fc-4480-bc76-00789e2db38d	c21e9bfb-7363-45ef-872b-44072c9eab20	fd9499da-e2f4-479c-8dd1-d76c69c87dde	f	\N	\N	\N	2025-02-08 20:27:00.246	2025-02-08 20:27:00.246
33f9b487-620a-4503-a1ee-4dccdba6dabf	c21e9bfb-7363-45ef-872b-44072c9eab20	f015ea7a-64d8-4e6c-95da-b753da906250	f	\N	\N	\N	2025-02-08 20:27:00.656	2025-02-08 20:27:00.656
7b2b0504-ff96-41bd-ae33-5bdffcd9c70f	c21e9bfb-7363-45ef-872b-44072c9eab20	e371d17f-3da7-42a6-84cd-9a4a7e9768bb	f	\N	\N	\N	2025-02-08 20:27:01.06	2025-02-08 20:27:01.06
\.


--
-- Data for Name: SizeChart; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."SizeChart" (id, name, "categoryId", "subcategoryId", "subsubcategoryId", unit, columns, rows, note, image, "isActive", "createdAt", "updatedAt") FROM stdin;
de272d7e-e7f2-47e3-998f-4c57a4665277	Men Shirt	\N	162123b5-cd08-4c06-b00b-9bcad9b6bbc7	\N	inch	["Size", "Chest", "Length", "Shoulder"]	[["S", "38", "27", "17"], ["M", "40", "28", "18"], ["L", "42", "29", "19"], ["XL", "44", "30", "20"], ["XLL", "46", "31", "21"]]	\N	\N	t	2026-10-24 20:18:46.776	2026-10-24 20:18:46.776
787fdfbb-0c27-404e-9a91-84be96b99d24	Polo	\N	553c3bb0-4e4d-4573-9f30-1eaaa11fdfe9	\N	inch	["Size", "Chest", "Length", "Shoulder"]	[["S", "38", "27", "17"], ["M", "40", "28", "18"], ["L", "42", "29", "19"], ["XL", "44", "30", "20"], ["XLL", "46", "31", "21"]]	\N	\N	t	2026-10-24 20:19:19.636	2026-10-24 20:19:19.636
\.


--
-- Data for Name: Subcategory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Subcategory" (id, "categoryId", name, image, slug, "isActive", "createdAt", "updatedAt") FROM stdin;
162123b5-cd08-4c06-b00b-9bcad9b6bbc7	5d9071c7-aa35-4165-83b1-b8a6468ad556	Shirt	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792833469/subcategory/g9sfh6dzhdegoruyeecv.webp	shirt	t	2026-10-24 09:17:49.592	2026-10-24 09:17:49.592
88ae1a34-ea1c-4704-ae77-0b6a346955b6	b09305fb-3470-4f62-a4a9-576813e3fb8d	Kurti	\N	kurti	t	2026-10-24 09:33:20.246	2026-10-24 09:33:20.246
488ef54a-c290-474f-be0c-ce9ee125e7b1	b09305fb-3470-4f62-a4a9-576813e3fb8d	New IN	\N	new-in	t	2026-10-24 09:36:02.883	2026-10-24 09:36:02.883
b669cc73-17ee-4e6d-adba-d1614f262971	5d9071c7-aa35-4165-83b1-b8a6468ad556	Pant	https://res.cloudinary.com/dpo6lmbzc/image/upload/v1792838765/subcategory/lsausl5zb7p8pej9gwun.webp	pant	t	2026-10-24 09:32:29.465	2026-10-24 10:46:05.981
553c3bb0-4e4d-4573-9f30-1eaaa11fdfe9	5d9071c7-aa35-4165-83b1-b8a6468ad556	Polo	\N	polo	t	2026-10-24 19:25:20.596	2026-10-24 19:25:20.596
b562e88b-35c6-48e0-baf1-e810fd335869	204873a3-bdff-478c-bd70-8cd370df47f4	Formal Shoes	\N	formal-shoes	t	2026-10-24 19:26:01.289	2026-10-24 19:26:01.289
041300cc-2e52-4aab-abdd-0472896fd3be	204873a3-bdff-478c-bd70-8cd370df47f4	Snekars	\N	snekars	t	2026-10-24 19:26:16.669	2026-10-24 19:26:16.669
9b598ca0-efb8-48bd-b277-9c5b6af872b0	204873a3-bdff-478c-bd70-8cd370df47f4	Sandle	\N	sandle	t	2026-10-24 19:26:39.678	2026-10-24 19:26:39.678
4d6fa67a-3950-489c-bfec-cdd33c19130d	c9a87de0-bce7-42ec-abb3-e8cdf407183e	Belt	\N	belt	t	2026-10-24 19:27:13.054	2026-10-24 19:27:13.054
6fa56a84-74be-448b-95d5-68b62bd99994	c9a87de0-bce7-42ec-abb3-e8cdf407183e	Sunglass	\N	sunglass	t	2026-10-24 19:27:23.925	2026-10-24 19:27:23.925
0a408976-54c5-4c7e-bffa-feab310dd05f	1d565b94-3d41-4232-b58b-bb06ab78bdf5	Kids Shirt	\N	kids-shirt	t	2026-10-24 19:27:53.808	2026-10-24 19:27:53.808
83ace33e-3aa3-45e5-aa48-0fbdd1c3a4cd	1d565b94-3d41-4232-b58b-bb06ab78bdf5	Kids Jacket	\N	kids-jacket	t	2026-10-24 19:28:01.934	2026-10-24 19:28:01.934
81870d91-3f4a-44b5-aad3-bea04a543c34	74342a43-b564-48b4-9b33-18c51aa6e213	1 Month	\N	1-month	t	2026-10-24 19:28:15.935	2026-10-24 19:28:15.935
ec0d6bd8-f809-40dd-bdd4-380761c1a0a3	74342a43-b564-48b4-9b33-18c51aa6e213	6 Month	\N	6-month	t	2026-10-24 19:28:22.009	2026-10-24 19:28:22.009
703d16bc-bd53-4e00-95b7-605f9e7357fd	74342a43-b564-48b4-9b33-18c51aa6e213	10 Month	\N	10-month	t	2026-10-24 19:28:30.483	2026-10-24 19:28:30.483
76995099-694a-42d7-a106-ef73cd5ba09c	39a623bc-9948-45c9-935d-7f104dd61593	Football Jersy	\N	football-jersy	t	2026-10-24 19:28:48.526	2026-10-24 19:28:48.526
67ccab7c-84cb-4bc1-9c54-14df05ac2635	39a623bc-9948-45c9-935d-7f104dd61593	Cricket Jersy	\N	cricket-jersy	t	2026-10-24 19:28:58.134	2026-10-24 19:28:58.134
7adfc369-5b11-418a-8905-b2bb3b17204f	a1e108b2-5ad2-4e81-93e6-cb15b278ecec	Bed Sheet	\N	bed-sheet	t	2026-10-24 19:29:10.985	2026-10-24 19:29:10.985
e2b2217c-ca47-41a6-8f16-775cde5fb88f	a1e108b2-5ad2-4e81-93e6-cb15b278ecec	Frame	\N	frame	t	2026-10-24 19:29:22.517	2026-10-24 19:29:22.517
\.


--
-- Data for Name: Subsubcategory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Subsubcategory" (id, "categoryId", "subcategoryId", name, image, slug, "isActive", "createdAt", "updatedAt") FROM stdin;
04cac189-f852-4068-852b-61dbc8f8fcfc	5d9071c7-aa35-4165-83b1-b8a6468ad556	162123b5-cd08-4c06-b00b-9bcad9b6bbc7	Full Sleve	\N	full-sleve	t	2026-10-24 09:22:53.714	2026-10-24 09:22:53.714
f655b6bb-79eb-48c8-af1d-85f03a7d7986	5d9071c7-aa35-4165-83b1-b8a6468ad556	162123b5-cd08-4c06-b00b-9bcad9b6bbc7	Half Sleve	\N	half-sleve	t	2026-10-24 09:23:30.679	2026-10-24 09:23:30.679
bbe56d99-e69f-4cc2-9954-77c1bd9f7236	5d9071c7-aa35-4165-83b1-b8a6468ad556	162123b5-cd08-4c06-b00b-9bcad9b6bbc7	Formal Shirt	\N	formal-shirt	t	2026-10-24 09:23:41.797	2026-10-24 09:23:41.797
732f5a4b-c6bc-4160-a007-3d156dd9ecc1	5d9071c7-aa35-4165-83b1-b8a6468ad556	162123b5-cd08-4c06-b00b-9bcad9b6bbc7	Casual Shirt	\N	casual-shirt	t	2026-10-24 09:23:50.827	2026-10-24 09:23:50.827
91761453-1ae4-4a43-927d-0e50d9f6f015	5d9071c7-aa35-4165-83b1-b8a6468ad556	b669cc73-17ee-4e6d-adba-d1614f262971	Formal Pant	\N	formal-pant	t	2026-10-24 09:32:51.974	2026-10-24 09:32:51.974
2d4d060e-4642-4fb3-93f5-abd655475485	5d9071c7-aa35-4165-83b1-b8a6468ad556	b669cc73-17ee-4e6d-adba-d1614f262971	Jeans	\N	jeans	t	2026-10-24 09:33:02.431	2026-10-24 09:33:02.431
a665f7cb-5547-40c4-964f-e9e753fc0a08	39a623bc-9948-45c9-935d-7f104dd61593	76995099-694a-42d7-a106-ef73cd5ba09c	Club Jersy	\N	club-jersy	t	2026-10-24 19:35:56.309	2026-10-24 19:35:56.309
3b249463-1907-4598-82dc-819b1f83e018	39a623bc-9948-45c9-935d-7f104dd61593	76995099-694a-42d7-a106-ef73cd5ba09c	International Jersy	\N	international-jersy	t	2026-10-24 19:36:07.468	2026-10-24 19:36:07.468
\.


--
-- Data for Name: Supplier; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Supplier" (id, "userId", name, address, phone, email, "createdBy", "updatedBy", "deletedBy", "isDeleted", "createdAt", "updatedAt") FROM stdin;
d22f66e4-8c79-48b8-9996-172e931e5164	8379673b-413b-42f1-95cd-903c8340df0a	Baily Road	AQP Shopping	+880 1622-534977		8379673b-413b-42f1-95cd-903c8340df0a	\N	\N	f	2025-09-06 20:56:39.223	2025-09-06 20:56:39.223
e49ce5d0-79ed-4644-b856-d421f6e30244	6a741d0b-e5d3-4ff6-b841-986a79cdce6f	Dhanmondi Strike	xyz	01748399860	shamimrahman920@gmail.com	6a741d0b-e5d3-4ff6-b841-986a79cdce6f	\N	\N	f	2025-09-16 17:45:54.499	2025-09-16 17:45:54.499
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."User" (id, "roleId", "parentId", name, email, phone, address, "billingAddress", country, city, "postalCode", image, password, otp, "otpCount", "initialPaymentAmount", "initialPaymentDue", "installmentTime", "refreshToken", "isActive", "isDeleted", "createdBy", "updatedBy", "deletedBy", "createdAt", "updatedAt") FROM stdin;
f2d508c7-824d-4a8b-be86-d1ccff9028a1	c21e9bfb-7363-45ef-872b-44072c9eab20	\N	Strike	strike@gmail.com	01987263542	Dhaka	Dhaka	Bangladesh	Dhaka	\N	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	\N	0	0	0	0	\N	t	t	\N	\N	6a741d0b-e5d3-4ff6-b841-986a79cdce6f	2025-02-08 20:26:27.579	2025-02-22 10:16:36.849
04919902-1fd3-43e4-b8b7-263543b9f6fa	c21e9bfb-7363-45ef-872b-44072c9eab20	\N	Deepta Barua	deepta.barua@northsouth.edu	01775172680	Dhaka	Dhaka	Bangladesh	Dhaka	\N	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	\N	16	0	0	0	\N	t	f	\N	\N	\N	2025-02-08 20:26:26.76	2025-02-21 20:52:27.311
26d64040-6f1c-4349-b4dc-079fcc7d767b	\N	\N	Sadman Shahariar 	sadman131313@gmail.com	01714690345	Mohammadpur,Shekhertech Road no 9 -House no 19	Mohammed pur,Shekhertech Road no 9 -House no 19	Bangladesh	Dhaka		https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	\N	2	0	0	0	\N	t	f	\N	\N	\N	2025-05-26 18:30:02.821	2025-05-26 19:04:37.389
f93f90b9-369b-4b3b-82f7-eb8ed55c69d2	\N	\N	Ohiduzzaman ishad	ishadmd1@gmail.com	01905038674	Konabari 	Konabari,Gazipur 	Bangladesh 	Gazipur 	1346	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	\N	1	0	0	0	\N	t	f	\N	\N	\N	2025-06-15 17:24:04.083	2025-06-15 17:24:59.528
5bcb774d-9038-4168-8bd1-dded8f26d907	\N	\N	Tasbiul Hasan	tasbiulhasan08@gmail.com	01748541038	 84 Mogbazar, Dhaka, Bangladesh	84 Mogbazar, Dhaka, Bangladesh	Bangladesh	Dhaka, Bangladesh	1217	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	\N	1	0	0	0	\N	t	t	\N	\N	6a741d0b-e5d3-4ff6-b841-986a79cdce6f	2025-02-21 06:22:32.294	2025-02-21 18:45:13.532
d04f8117-f9ae-41de-8f92-245107e4d035	1a843360-237c-4dce-ba8b-9a077bafdd1e	\N	Customer 1	damlip195@ichigo.me	01875172682	Dhaka	Dhaka	Bangladesh	Dhaka	\N	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	\N	0	0	0	0	\N	t	t	\N	\N	6a741d0b-e5d3-4ff6-b841-986a79cdce6f	2025-02-08 20:26:29.128	2025-02-22 10:15:59.958
1d1ec74d-8ef0-455e-af2a-08e89350b6f9	51c3a14d-55e8-4103-b84e-0906f08fe41d	\N	Manager1	manager1@gmail.com	01875172681	Dhaka	Dhaka	Bangladesh	Dhaka	\N	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	\N	0	0	0	0	\N	t	t	\N	\N	6a741d0b-e5d3-4ff6-b841-986a79cdce6f	2025-02-08 20:26:28.706	2025-02-22 10:16:25.56
afeb9906-09dc-4a98-8006-a97d90a67cb9	\N	\N	Rajbarmon	rajbarman845@gmail.com	01785728157	Chowk Bazar 	Bismillah Tower 	Bangladesh 	Dhaka 	1100	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	\N	1	0	0	0	\N	t	f	\N	\N	\N	2025-06-18 09:36:04.322	2025-06-18 09:36:47.869
1a7ffb0e-fec0-4dd5-8acb-59db99ee9a60	\N	\N	mehedi hasan	mdmehdikhan850@gmail.com	01787485917	22/4north golapbag dhaka	22/4north golapbag dhaka	BD	Dhaka	1203	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	\N	1	0	0	0	\N	t	f	\N	\N	\N	2025-08-22 19:58:35.989	2025-08-22 20:00:41.514
8379673b-413b-42f1-95cd-903c8340df0a	c21e9bfb-7363-45ef-872b-44072c9eab20	\N	Yasin Yasin Ahmed UIUX Ahmed	yasinahmed496@gmail.com	01712581668	3/A, New Bailey Road, DHaka	3/A, New Bailey Road, DHaka	Bangladesh	Dhaka	105	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	\N	3	0	0	0	\N	t	f	\N	6a741d0b-e5d3-4ff6-b841-986a79cdce6f	\N	2025-04-05 16:23:17.383	2025-09-06 20:51:08.777
9989f3f5-450e-4276-8371-6b75c89e3afc	\N	\N	Tahmid Hasan	htahmid699@gmail.com	01712593203	Sylhet Chhatak tengargow 	Chhatak 	BD	Sylhet 	3080	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	663313	1	0	0	0	\N	t	f	\N	\N	\N	2025-08-27 08:21:47.86	2025-08-27 08:22:31.597
6a741d0b-e5d3-4ff6-b841-986a79cdce6f	c21e9bfb-7363-45ef-872b-44072c9eab20	\N	Shamim Rahman	shamimrahman920@gmail.com	01827364523	Dhaka	Dhaka	Bangladesh	Dhaka	\N	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	974219	55	0	0	0	\N	t	f	\N	\N	\N	2025-02-08 20:26:28.192	2025-09-21 19:40:20.691
d25d1bb5-1af2-4cf0-97b5-881d4622206d	\N	\N	Mahir wasif	mahirwasifl@gmail.com	01835939468	Bawal mirzapur Bazar gazipur 	Mirzapur bazar	Bangladesh 	Gazipur 	1700	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	\N	1	0	0	0	\N	t	f	\N	\N	\N	2025-09-10 08:30:44.979	2025-09-10 08:31:20.433
f5dc8814-e7ae-46f2-ad1c-4b3aa2699fe4	\N	\N	Shamim Rahman	shamimrahman90@gmail.com	01748399860	Kakrail	Bailyroad	Bangladesh	bailyroad	1217	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	\N	0	0	0	0	\N	t	f	\N	\N	\N	2025-09-20 17:47:55.417	2025-09-20 17:47:55.417
7bf0f685-607c-4216-b78c-400ecd60d774	\N	\N	Koushik Biswas	koushikbiswas2408@gmail.com	01777616560	2no old school lane thanapa,kushtia	Kushtia	BD	Kushtia	7000	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	\N	0	0	0	0	\N	t	f	\N	\N	\N	2025-09-16 13:36:19.564	2025-09-16 13:36:19.564
433c42b3-a2ce-4a31-8417-fc9dff119a7b	\N	\N	Rafin	tasniftarin184@gmail.com	01614733985	Bashundora 	Bashundora 	Bangladesh	Dhaka		https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	\N	1	0	0	0	\N	t	f	\N	\N	\N	2025-09-16 14:19:10.244	2025-09-16 14:19:49.832
6c90828f-8ac8-436d-896e-5e7523abad27	\N	\N	Ali 	abcd3433@gmail.com	1234	101/1A , Mirpur, Dhaka 	101/1A , Mirpur, Dhaka 	Bangladesh 	Dhaka	1216	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	979874	1	0	0	0	\N	t	f	\N	\N	\N	2025-10-01 14:03:05.487	2025-10-01 14:03:12.169
7e8965ad-c602-4a38-adcc-7832226ea45c	\N	\N	Shamim Rahman	shamimrocky801@yahoo.com	01703493394	Kakrail	Bailyroad	Bangladesh	bailyroad	1217	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	112210	1	0	0	0	\N	t	f	\N	\N	\N	2025-09-20 17:49:30.352	2025-09-20 17:49:35.562
43fced64-70ae-4fd1-a686-f169f260efc7	\N	\N	Hasan	rashid.ali49208@gmail.com	12345	101/1A , Mirpur, Dhaka 	101/1A , Mirpur, Dhaka 	Bangladesh 	Dhaka	1216	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	574601	1	0	0	0	\N	t	f	\N	\N	\N	2025-10-01 14:04:38.404	2025-10-01 14:04:43.538
bb2a8634-4ba6-4e42-89a2-6a5b41cd9209	c21e9bfb-7363-45ef-872b-44072c9eab20	\N	Ayman	aymanmehedi6@gmail.com	01844288187	Bailyroad	Bailyroad	Bangladesh	bailyroad	\N	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	\N	1	0	0	0	\N	t	t	6a741d0b-e5d3-4ff6-b841-986a79cdce6f	\N	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	2025-04-03 19:06:57.508	2025-10-03 14:19:35.239
86a4448a-7081-416a-a191-1178ceed973c	c21e9bfb-7363-45ef-872b-44072c9eab20	\N	Ekram	ekram.eshan9090@gmail.com	01633657655	Bailyroad	Bailyroad	Bangladesh	Dhaka	\N	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	\N	0	\N	\N	\N	\N	t	t	6a741d0b-e5d3-4ff6-b841-986a79cdce6f	\N	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	2025-02-22 10:18:15.64	2025-10-03 14:19:39.061
38e185e5-2399-4d1c-83cb-e9e9339c0556	\N	\N	Jobain Ferdous	jofe69mgt@gmail.com	01635676059	South banasree,khilgaon,dhaka.	Khilgaon 	Bangladesh	Khilgaon	1100	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	949312	1	0	0	0	\N	t	f	\N	\N	\N	2025-10-22 20:40:51.005	2025-10-22 20:40:56.964
c6d27bb8-5f3d-4a69-89a8-e5ada85d3e98	\N	\N	Abrar Shahriar Niloy	niloyabrarshahriar@gmail.com	01623308543	South Hall of Residence, Islamic University of Technology, Boardbazar, Gazipur	South Hall of Residence, Islamic University of T	BD	Gazipur	1704	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	909248	1	0	0	0	\N	t	f	\N	\N	\N	2025-11-18 10:48:57.918	2025-11-18 10:49:09.366
caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	c21e9bfb-7363-45ef-872b-44072c9eab20	\N	clothingbrandstrike	clothingbrandstrike@gmail.com	0 1622534977	Baily Road	Baily Road	Bangladesh	Dhaka	\N	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	111111	123456	17	\N	\N	\N	\N	t	f	6a741d0b-e5d3-4ff6-b841-986a79cdce6f	\N	\N	2025-02-22 10:15:40.898	2025-09-19 20:19:21.019
c7cf1bc1-39b2-42fc-81c0-053ecd5ffbaa	\N	\N	Abidur Rahman	aralfi0183@gmail.com	01867470941	Kumarpara,Duptara,Araihazar, Narayanganj 	01867470941	Bangladesh	Duptara	1460	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	304846	1	0	0	0	\N	t	f	\N	\N	\N	2025-12-03 15:13:54.648	2025-12-03 15:14:06.205
c3f6ce1f-e5da-4c82-bdd5-58fbb76848ac	\N	\N	Ebne Sabit Eham 	sabiteham48@gmail.com	01337986369	Oxford mission road 	Barisal Oxford mission road 	Bangladesh 	Barisal 		https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	304963	1	0	0	0	\N	t	f	\N	\N	\N	2026-01-11 15:18:18.815	2026-01-11 15:19:02.596
ec3b8213-3541-49b5-bfd4-f17614bb220d	\N	\N	TAPUS	tapustripz@gmail.com	01635651914	Kalurghat Rastha matha.AL khan school Road Rofiq mention goli	Kalurghat Rashta matha AL Khan school	Bangladesh	Chittagong		https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	441913	1	0	0	0	\N	t	f	\N	\N	\N	2026-02-18 06:02:12.556	2026-02-18 06:02:30.688
9a299096-8e93-44f9-8cd0-05864ddf9411	\N	\N	Aditya	adityaraj9306@gmail.com	8007885002	Edyans us 37 hyda oai Bixyanui une , Saha Cora exdfa d, Behind Hyderabadi	Edyans us 37 hyda oai Bixyanui une , Saha Cora exdfa d, Behind Hyderabadi	India 	Pune	411058	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	\N	0	0	0	0	\N	t	f	\N	\N	\N	2026-04-26 08:48:09.326	2026-04-26 08:48:09.326
3b4687c5-221b-4a9b-acc2-83a31a825863	\N	\N	Tahsin Ahmed 	tahsinahmedpritom3@gmail.com	01403404498	Dhaka,savar chayabethi sohidmojnu road Life tower opposite building 	Life tower 	Bangladesh 	Dhaka savar 	1340	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	472126	1	0	0	0	\N	t	f	\N	\N	\N	2026-05-02 18:28:26.228	2026-05-02 18:28:36.92
9764f513-3e0c-42a9-a590-e6c764048187	\N	\N	Mubin 10	m31567271@gmail.com	+8801980600724	ILLIYEEN Multi-Brand Store (Uttara, Sector 14) ????????????????????????	ILLIYEEN Multi-Brand Store (Uttara, Sector 14) ????????????????????????	Bangladesh	Dhaka 	1230	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	\N	0	0	0	0	\N	t	f	\N	\N	\N	2026-05-08 18:57:14.447	2026-05-08 18:57:14.447
dda5b6e8-70c2-4bed-adb2-276a7b40bf96	\N	\N	Nahian	faiznahian6@gmail.com	01819337210	Chawkbazar , chittagong 	Chawkbazar, Chittagong 	Bangladesh 	Chittagong 		https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	739799	1	0	0	0	\N	t	f	\N	\N	\N	2026-05-22 05:09:10.283	2026-05-22 05:09:24.173
1205c61c-476a-4dd7-8297-bc4ccaeabc7a	\N	\N	Kaye Berger	sandexsimanji@gmail.com	+1 (276) 499-2758	Provident ut deseru	Deserunt ex quia mol	Sit ullamco quasi mo	Et perspiciatis ten	Vel est atque archit	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	\N	0	0	0	0	\N	t	f	\N	\N	\N	2026-06-12 15:33:51.18	2026-06-12 15:33:51.18
0422f993-23c0-43e9-b402-860caf280f37	\N	\N	Shsh	aaravshah2804@gmail.com	9825670846	B-401 hazelwood flats,near pratham cross roads,iskon road,harinagar gotri vadodra	B-401 hazelwood flats,near pratham cross roads,iskon road,harinagar gotri vadodra	India	Vadodra	390007	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	623750	1	0	0	0	\N	t	f	\N	\N	\N	2026-06-13 18:47:01.315	2026-06-13 18:47:07.033
a42fc2a1-696f-4bdf-8958-45240110dbae	\N	\N	Rayan Ahmed	roottuuu@gmail.com	01711466963	House#86, Road#5, Block#F, Banani, Dhaka-1213	House#86, Road#5, Block#F, Banani, Dhaka-1213	Bangladesh	Dhaka	1213	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	533529	1	0	0	0	\N	t	f	\N	\N	\N	2026-06-25 11:55:23.297	2026-06-25 11:55:29.903
b0b89d8a-94db-4301-9249-7819d331c756	\N	\N	Tahmid Hoque	tahmidhoq7820@gmail.com	 01882069096	 Haji Nurul Hoque shoudagor baari, dewan bazar bhora pukur paar, west bakalia, chawkbazar, chattogram 	Haji Nurul Hoque shoudagor baari, dewan bazar bhora pukur paar, west bakalia, chawkbazar, chattogram  	Bangladesh 	Chittagong 		https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	883602	1	0	0	0	\N	t	f	\N	\N	\N	2026-06-26 12:11:58.272	2026-06-26 12:12:14.289
64a04a3d-06ba-4834-a8c6-108f6716bfb6	\N	\N	AN IK	anikkumarbiswas2055@gmail.com	01401992055	Lagolbadh bazer 	Lagolbadh bazer 	Bangladesh 	Magura 		https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	\N	0	0	0	0	\N	t	f	\N	\N	\N	2026-07-06 06:13:54.078	2026-07-06 06:13:54.078
6aaee998-863e-4fc5-8155-72eb94ca6d1e	\N	\N	Yasir Zafar	yasirzafar066@gmail.com	+8801973650831	17/18 Hossain Housing Society,Shamoli,Dhaka. Beside Bangladesh Specialized Hospital. Building Name: Anwar Landmark Sensation	17/18 Hossain Housing Society, Shamoli,Dhaka	BD	Dhaka	1207	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	398516	1	0	0	0	\N	t	f	\N	\N	\N	2026-07-15 12:27:16.871	2026-07-15 12:27:27.506
cdef06e0-4d34-45a9-a1c1-a63c2312d9b6	\N	\N	Rafat Islam	rafatislam2009@gmail.com	01780286905	308/1 mirhazirbag,jatrabari,dhaka-1204	308/1 mirhazirbag,jatrabari,dhaka-1204	BD	Dhaka	1204	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	190221	1	0	0	0	\N	t	f	\N	\N	\N	2026-07-21 19:00:36.248	2026-07-21 19:00:50.534
e12fc3a2-5124-4368-a7c9-1abd0c50e927	\N	\N	Md. Shamim Rahmant	shamimrahman20@gmail.com	01748399864	\N	\N	\N	\N	\N	https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	\N	0	0	0	0	\N	t	f	\N	\N	\N	2026-08-25 20:19:37.202	2026-08-25 20:19:37.202
0b3f46ef-af5c-454d-979b-a67211f9b35a	\N	\N	P??r??sh ??h??km??	pareshchakma2007@gmail.com	01850100241	Savar Dhaka	Savar	Bangladesh 	Dhaka		https://cdn-icons-png.flaticon.com/512/9368/9368192.png	\N	\N	0	0	0	0	\N	t	t	\N	\N	caba2cce-d5e4-4d29-a87c-8f1eaa45b2aa	2026-01-16 06:14:51.5	2026-09-18 17:42:31.045
\.


--
-- Data for Name: Wishlist; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Wishlist" (id, "productId", "userId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: _ModuleToRole; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."_ModuleToRole" ("A", "B") FROM stdin;
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
d488a4d7-06d8-453c-939f-1f660fabd9b3	bf7855258f9ad41b3d3647f7d911dd10ecf2807d54826399556e785237f58d4f	2025-02-08 20:25:21.740982+00	20250104075749_init	\N	\N	2025-02-08 20:25:20.502817+00	1
345ca610-94eb-495a-9c5d-1cb3192a568e	e4fd150b187ec8b2db42630aa268fd3cd5499e40b902aaff3d10cda60c01725f	2025-02-08 20:25:22.7653+00	20250104130902_product	\N	\N	2025-02-08 20:25:22.038465+00	1
574aa5aa-ad79-447b-904c-255cb5d21289	2bd7f63e43e9a845b299ee6938fc9db6e4545d2647a0a6e3460a841c92930cc4	2025-02-08 20:25:24.190711+00	20250110074050_preorder	\N	\N	2025-02-08 20:25:23.223973+00	1
ead4ec16-bc7a-464c-90a2-36ca72319fe4	8747d9b636f15381b06f98d6945c7cdb40511cc2b11ba4954e8760f44b6a5971	2025-02-08 20:25:25.113308+00	20250111080404_add_urlfor_banner	\N	\N	2025-02-08 20:25:24.393636+00	1
a7ed011f-3d7f-49fb-999a-035ee28915ae	3b94116d19e5f3f52a21ca5612082b2857968f40a20a134929f95ca1ba3cea4b	2025-02-08 20:25:26.03153+00	20250112175200_madereviewcommentoptional	\N	\N	2025-02-08 20:25:25.419786+00	1
8e3d4e86-dcf7-4aaa-9640-24f22971aedf	d6657752900f46aa5d64b856787768dca4cf96f16ca3426386545e3a09f9098c	2025-02-08 20:25:26.854212+00	20250124100949_roleid_optional_in_user	\N	\N	2025-02-08 20:25:26.266998+00	1
23840067-9058-43f0-b734-37f22712cf0d	2d08092ce1105600e06c91817147383c92dc69f259f57e65d436ad51cac6fb3d	2025-02-08 20:25:27.628352+00	20250129163935_add_prod_attr_field_in_preorder	\N	\N	2025-02-08 20:25:27.053702+00	1
826f34b0-ab75-411c-a10f-fe3ae1262640	bf2d3e0abed5805fbf49bf9b5141216252ccad95e061decc7de919cad4e6c361	2025-02-08 20:25:28.58733+00	20250206184622_contact_and_newsletter	\N	\N	2025-02-08 20:25:27.870448+00	1
98694026-4601-4020-8e17-79bb08df0a06	a551e3f8ca7927990dd93e4f5bbf318a8d8d1e4fb650be51ce5fba154d15466b	2025-02-21 21:03:04.965936+00	20250221210304_order_status	\N	\N	2025-02-21 21:03:04.548823+00	1
\.


--
-- Name: Banner Banner_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Banner"
    ADD CONSTRAINT "Banner_pkey" PRIMARY KEY (id);


--
-- Name: Brand Brand_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Brand"
    ADD CONSTRAINT "Brand_pkey" PRIMARY KEY (id);


--
-- Name: Campaign Campaign_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Campaign"
    ADD CONSTRAINT "Campaign_pkey" PRIMARY KEY (id);


--
-- Name: Category Category_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Category"
    ADD CONSTRAINT "Category_pkey" PRIMARY KEY (id);


--
-- Name: Contact Contact_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Contact"
    ADD CONSTRAINT "Contact_pkey" PRIMARY KEY (id);


--
-- Name: Coupon Coupon_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Coupon"
    ADD CONSTRAINT "Coupon_pkey" PRIMARY KEY (id);


--
-- Name: CustomerRiskProfile CustomerRiskProfile_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."CustomerRiskProfile"
    ADD CONSTRAINT "CustomerRiskProfile_pkey" PRIMARY KEY (id);


--
-- Name: MasterProduct MasterProduct_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."MasterProduct"
    ADD CONSTRAINT "MasterProduct_pkey" PRIMARY KEY (id);


--
-- Name: Module Module_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Module"
    ADD CONSTRAINT "Module_pkey" PRIMARY KEY (id);


--
-- Name: Newsletter Newsletter_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Newsletter"
    ADD CONSTRAINT "Newsletter_pkey" PRIMARY KEY (id);


--
-- Name: OrderItem OrderItem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."OrderItem"
    ADD CONSTRAINT "OrderItem_pkey" PRIMARY KEY (id);


--
-- Name: Order Order_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Order"
    ADD CONSTRAINT "Order_pkey" PRIMARY KEY (id);


--
-- Name: Payment Payment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Payment"
    ADD CONSTRAINT "Payment_pkey" PRIMARY KEY (id);


--
-- Name: Preorder Preorder_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Preorder"
    ADD CONSTRAINT "Preorder_pkey" PRIMARY KEY (id);


--
-- Name: ProductAttribute ProductAttribute_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ProductAttribute"
    ADD CONSTRAINT "ProductAttribute_pkey" PRIMARY KEY (id);


--
-- Name: ProductImage ProductImage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ProductImage"
    ADD CONSTRAINT "ProductImage_pkey" PRIMARY KEY (id);


--
-- Name: Product Product_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Product"
    ADD CONSTRAINT "Product_pkey" PRIMARY KEY (id);


--
-- Name: Review Review_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Review"
    ADD CONSTRAINT "Review_pkey" PRIMARY KEY (id);


--
-- Name: RoleModule RoleModule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."RoleModule"
    ADD CONSTRAINT "RoleModule_pkey" PRIMARY KEY (id);


--
-- Name: Role Role_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Role"
    ADD CONSTRAINT "Role_pkey" PRIMARY KEY (id);


--
-- Name: SizeChart SizeChart_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."SizeChart"
    ADD CONSTRAINT "SizeChart_pkey" PRIMARY KEY (id);


--
-- Name: Subcategory Subcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Subcategory"
    ADD CONSTRAINT "Subcategory_pkey" PRIMARY KEY (id);


--
-- Name: Subsubcategory Subsubcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Subsubcategory"
    ADD CONSTRAINT "Subsubcategory_pkey" PRIMARY KEY (id);


--
-- Name: Supplier Supplier_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Supplier"
    ADD CONSTRAINT "Supplier_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: Wishlist Wishlist_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Wishlist"
    ADD CONSTRAINT "Wishlist_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: Brand_name_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Brand_name_key" ON public."Brand" USING btree (name);


--
-- Name: CustomerRiskProfile_phoneNumber_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "CustomerRiskProfile_phoneNumber_key" ON public."CustomerRiskProfile" USING btree ("phoneNumber");


--
-- Name: MasterProduct_active_deleted_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "MasterProduct_active_deleted_idx" ON public."MasterProduct" USING btree ("isActive", "isDeleted");


--
-- Name: MasterProduct_brandId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "MasterProduct_brandId_idx" ON public."MasterProduct" USING btree ("brandId");


--
-- Name: MasterProduct_categoryId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "MasterProduct_categoryId_idx" ON public."MasterProduct" USING btree ("categoryId");


--
-- Name: MasterProduct_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "MasterProduct_name_idx" ON public."MasterProduct" USING btree (name);


--
-- Name: MasterProduct_subcategoryId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "MasterProduct_subcategoryId_idx" ON public."MasterProduct" USING btree ("subcategoryId");


--
-- Name: MasterProduct_subsubcategoryId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "MasterProduct_subsubcategoryId_idx" ON public."MasterProduct" USING btree ("subsubcategoryId");


--
-- Name: Order_orderSource_createdAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Order_orderSource_createdAt_idx" ON public."Order" USING btree ("orderSource", "createdAt");


--
-- Name: Product_masterProductId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Product_masterProductId_idx" ON public."Product" USING btree ("masterProductId");


--
-- Name: SizeChart_categoryId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "SizeChart_categoryId_idx" ON public."SizeChart" USING btree ("categoryId");


--
-- Name: SizeChart_subcategoryId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "SizeChart_subcategoryId_idx" ON public."SizeChart" USING btree ("subcategoryId");


--
-- Name: SizeChart_subsubcategoryId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "SizeChart_subsubcategoryId_idx" ON public."SizeChart" USING btree ("subsubcategoryId");


--
-- Name: Subcategory_name_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Subcategory_name_key" ON public."Subcategory" USING btree (name);


--
-- Name: Subsubcategory_name_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Subsubcategory_name_key" ON public."Subsubcategory" USING btree (name);


--
-- Name: _ModuleToRole_AB_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "_ModuleToRole_AB_unique" ON public."_ModuleToRole" USING btree ("A", "B");


--
-- Name: _ModuleToRole_B_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "_ModuleToRole_B_index" ON public."_ModuleToRole" USING btree ("B");


--
-- Name: idx_order_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_created_at ON public."Order" USING btree ("createdAt");


--
-- Name: idx_order_item_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_item_order_id ON public."OrderItem" USING btree ("orderId");


--
-- Name: idx_order_item_product_attribute_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_item_product_attribute_id ON public."OrderItem" USING btree ("productAttributeId");


--
-- Name: idx_order_item_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_item_product_id ON public."OrderItem" USING btree ("productId");


--
-- Name: idx_order_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_status ON public."Order" USING btree (status);


--
-- Name: idx_order_user_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_user_created ON public."Order" USING btree ("userId", "createdAt");


--
-- Name: idx_order_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_user_id ON public."Order" USING btree ("userId");


--
-- Name: idx_product_attribute_is_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_attribute_is_deleted ON public."ProductAttribute" USING btree ("isDeleted");


--
-- Name: idx_product_attribute_product_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_attribute_product_deleted ON public."ProductAttribute" USING btree ("productId", "isDeleted");


--
-- Name: idx_product_attribute_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_attribute_product_id ON public."ProductAttribute" USING btree ("productId");


--
-- Name: idx_product_attribute_stock_amount; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_attribute_stock_amount ON public."ProductAttribute" USING btree ("stockAmount");


--
-- Name: idx_product_barcode; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_barcode ON public."Product" USING btree (barcode);


--
-- Name: idx_product_brand_active_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_brand_active_deleted ON public."Product" USING btree ("brandId", "isActive", "isDeleted");


--
-- Name: idx_product_brand_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_brand_id ON public."Product" USING btree ("brandId");


--
-- Name: idx_product_campaign_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_campaign_id ON public."Product" USING btree ("campaignId");


--
-- Name: idx_product_category_active_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_category_active_deleted ON public."Product" USING btree ("categoryId", "isActive", "isDeleted");


--
-- Name: idx_product_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_category_id ON public."Product" USING btree ("categoryId");


--
-- Name: idx_product_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_created_at ON public."Product" USING btree ("createdAt");


--
-- Name: idx_product_image_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_image_product_id ON public."ProductImage" USING btree ("productId");


--
-- Name: idx_product_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_is_active ON public."Product" USING btree ("isActive");


--
-- Name: idx_product_is_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_is_deleted ON public."Product" USING btree ("isDeleted");


--
-- Name: idx_product_product_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_product_code ON public."Product" USING btree ("productCode");


--
-- Name: idx_product_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_slug ON public."Product" USING btree (slug);


--
-- Name: idx_product_subcategory_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_subcategory_id ON public."Product" USING btree ("subcategoryId");


--
-- Name: idx_product_subsubcategory_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_subsubcategory_id ON public."Product" USING btree ("subsubcategoryId");


--
-- Name: idx_product_supplier_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_supplier_id ON public."Product" USING btree ("supplierId");


--
-- Name: idx_product_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_user_id ON public."Product" USING btree ("userId");


--
-- Name: idx_review_product_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_review_product_created ON public."Review" USING btree ("productId", "createdAt");


--
-- Name: idx_review_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_review_product_id ON public."Review" USING btree ("productId");


--
-- Name: idx_review_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_review_user_id ON public."Review" USING btree ("userId");


--
-- Name: idx_risk_profile_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_risk_profile_phone ON public."CustomerRiskProfile" USING btree ("phoneNumber");


--
-- Name: idx_wishlist_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wishlist_product_id ON public."Wishlist" USING btree ("productId");


--
-- Name: idx_wishlist_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wishlist_user_id ON public."Wishlist" USING btree ("userId");


--
-- Name: idx_wishlist_user_product; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wishlist_user_product ON public."Wishlist" USING btree ("userId", "productId");


--
-- Name: Campaign Campaign_categoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Campaign"
    ADD CONSTRAINT "Campaign_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES public."Category"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Campaign Campaign_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Campaign"
    ADD CONSTRAINT "Campaign_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Category Category_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Category"
    ADD CONSTRAINT "Category_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: MasterProduct MasterProduct_brandId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."MasterProduct"
    ADD CONSTRAINT "MasterProduct_brandId_fkey" FOREIGN KEY ("brandId") REFERENCES public."Brand"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: MasterProduct MasterProduct_categoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."MasterProduct"
    ADD CONSTRAINT "MasterProduct_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES public."Category"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: MasterProduct MasterProduct_subcategoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."MasterProduct"
    ADD CONSTRAINT "MasterProduct_subcategoryId_fkey" FOREIGN KEY ("subcategoryId") REFERENCES public."Subcategory"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: MasterProduct MasterProduct_subsubcategoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."MasterProduct"
    ADD CONSTRAINT "MasterProduct_subsubcategoryId_fkey" FOREIGN KEY ("subsubcategoryId") REFERENCES public."Subsubcategory"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: OrderItem OrderItem_orderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."OrderItem"
    ADD CONSTRAINT "OrderItem_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES public."Order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: OrderItem OrderItem_productAttributeId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."OrderItem"
    ADD CONSTRAINT "OrderItem_productAttributeId_fkey" FOREIGN KEY ("productAttributeId") REFERENCES public."ProductAttribute"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: OrderItem OrderItem_productId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."OrderItem"
    ADD CONSTRAINT "OrderItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES public."Product"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Order Order_couponId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Order"
    ADD CONSTRAINT "Order_couponId_fkey" FOREIGN KEY ("couponId") REFERENCES public."Coupon"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Order Order_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Order"
    ADD CONSTRAINT "Order_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Payment Payment_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Payment"
    ADD CONSTRAINT "Payment_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Preorder Preorder_productAttributeId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Preorder"
    ADD CONSTRAINT "Preorder_productAttributeId_fkey" FOREIGN KEY ("productAttributeId") REFERENCES public."ProductAttribute"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Preorder Preorder_productId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Preorder"
    ADD CONSTRAINT "Preorder_productId_fkey" FOREIGN KEY ("productId") REFERENCES public."Product"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Preorder Preorder_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Preorder"
    ADD CONSTRAINT "Preorder_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ProductAttribute ProductAttribute_productId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ProductAttribute"
    ADD CONSTRAINT "ProductAttribute_productId_fkey" FOREIGN KEY ("productId") REFERENCES public."Product"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ProductImage ProductImage_productId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ProductImage"
    ADD CONSTRAINT "ProductImage_productId_fkey" FOREIGN KEY ("productId") REFERENCES public."Product"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Product Product_brandId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Product"
    ADD CONSTRAINT "Product_brandId_fkey" FOREIGN KEY ("brandId") REFERENCES public."Brand"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Product Product_campaignId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Product"
    ADD CONSTRAINT "Product_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES public."Campaign"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Product Product_categoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Product"
    ADD CONSTRAINT "Product_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES public."Category"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Product Product_masterProductId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Product"
    ADD CONSTRAINT "Product_masterProductId_fkey" FOREIGN KEY ("masterProductId") REFERENCES public."MasterProduct"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Product Product_subcategoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Product"
    ADD CONSTRAINT "Product_subcategoryId_fkey" FOREIGN KEY ("subcategoryId") REFERENCES public."Subcategory"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Product Product_subsubcategoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Product"
    ADD CONSTRAINT "Product_subsubcategoryId_fkey" FOREIGN KEY ("subsubcategoryId") REFERENCES public."Subsubcategory"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Product Product_supplierId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Product"
    ADD CONSTRAINT "Product_supplierId_fkey" FOREIGN KEY ("supplierId") REFERENCES public."Supplier"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Product Product_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Product"
    ADD CONSTRAINT "Product_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Review Review_productId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Review"
    ADD CONSTRAINT "Review_productId_fkey" FOREIGN KEY ("productId") REFERENCES public."Product"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Review Review_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Review"
    ADD CONSTRAINT "Review_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: RoleModule RoleModule_moduleId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."RoleModule"
    ADD CONSTRAINT "RoleModule_moduleId_fkey" FOREIGN KEY ("moduleId") REFERENCES public."Module"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: RoleModule RoleModule_roleId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."RoleModule"
    ADD CONSTRAINT "RoleModule_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES public."Role"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Subcategory Subcategory_categoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Subcategory"
    ADD CONSTRAINT "Subcategory_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES public."Category"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Subsubcategory Subsubcategory_categoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Subsubcategory"
    ADD CONSTRAINT "Subsubcategory_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES public."Category"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Subsubcategory Subsubcategory_subcategoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Subsubcategory"
    ADD CONSTRAINT "Subsubcategory_subcategoryId_fkey" FOREIGN KEY ("subcategoryId") REFERENCES public."Subcategory"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Supplier Supplier_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Supplier"
    ADD CONSTRAINT "Supplier_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: User User_parentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: User User_roleId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES public."Role"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Wishlist Wishlist_productId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Wishlist"
    ADD CONSTRAINT "Wishlist_productId_fkey" FOREIGN KEY ("productId") REFERENCES public."Product"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Wishlist Wishlist_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Wishlist"
    ADD CONSTRAINT "Wishlist_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _ModuleToRole _ModuleToRole_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."_ModuleToRole"
    ADD CONSTRAINT "_ModuleToRole_A_fkey" FOREIGN KEY ("A") REFERENCES public."Module"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _ModuleToRole _ModuleToRole_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."_ModuleToRole"
    ADD CONSTRAINT "_ModuleToRole_B_fkey" FOREIGN KEY ("B") REFERENCES public."Role"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict yLIEAbyjDTdDXmsfhSLQexoKayo99ENWlHyeSaANTa8nbKFlptmJgZ62fiVDFtH

