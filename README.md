# Borneo Business Intelligence Network

V1 core for a professional Borneo opportunity + business graph platform.

## V1
- Public market homepage with truthful KPI policy
- 100 verified 2026 public procurement records: Sabah 35, Sarawak 30, Brunei 35
- Every record preserves its official source URL
- Opportunities, Companies/Buyers, Market, Network and Pipeline surfaces
- Supabase Auth sign-in and company onboarding
- Company capability data model for Personal Business Radar matching
- Deal pipeline and verified business-generated attribution model
- RLS-first Supabase schema with explicit Data API grants

## Metrics policy
Never seed or fabricate outcomes. V1 starts at **0 Verified Deals / RM0 Verified Business Generated**. Public business-generated numbers may only change after a deal is explicitly verified.

## Data sources
- Sabah State Library official quotation notices
- Sarawak Government eTender notices
- Brunei Ministry of Defence official quotation notices

## Deploy
1. Create a dedicated Supabase project.
2. Apply `supabase/migrations/001_initial_schema.sql`.
3. Import the 100 verified records from `data/sabah.json`, `data/sarawak.json`, and `data/brunei.json` into `public.opportunities`.
4. Set `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` in Vercel.
5. Deploy with Next.js defaults.
